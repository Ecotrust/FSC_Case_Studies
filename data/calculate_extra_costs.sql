--ALTER TABLE fvs_econsummary
--ADD COLUMN npv_adj real,
--ADD COLUMN nfv_adj real,
--ADD COLUMN undiscounted_revenue_adj real,
--ADD COLUMN discounted_revenue_adj real,
--ADD COLUMN undiscounted_cost_adj real,
--ADD COLUMN discounted_cost_adj real;

-- calculate total NPV, and total undiscounted future value (NFV)
UPDATE fvs_econsummary
SET npv_adj = discounted_revenue - total_discounted_cost,
	nfv_adj = undiscounted_revenue - total_undiscounted_cost,
	undiscounted_revenue_adj = undiscounted_revenue,
	discounted_revenue_adj = discounted_revenue,
	undiscounted_cost_adj = total_undiscounted_cost,
	discounted_cost_adj = total_discounted_cost
	mrch_boardfoot_volume_adj = mrch_boardfoot_volume;

-- SET npv_adj, nfv_adj, and cumulative_MBF to zero for pretend harvests
UPDATE fvs_econsummary
SET npv_adj = 0,
	nfv_adj = 0,
	cumulative_MBF = 0,
	undiscounted_revenue_adj = 0,
	discounted_revenue_adj = 0,
	undiscounted_cost_adj = 0,
	discounted_cost_adj = 0,
	mrch_boardfoot_volume_adj = 0
WHERE fvs_econsummary.pretend_harvest = 'YES';

--ALTER TABLE fvs_econsummary
--ADD COLUMN cumulative_MBF real;

-- calculate cumulative harvest volume
UPDATE fvs_econsummary
	SET cumulative_MBF = foo.cum_BF/1000.
	FROM (SELECT caseid, year,
		SUM(mrch_boardfoot_volume_adj) OVER (PARTITION BY caseid ORDER BY year) AS cum_BF
			FROM fvs_econsummary
		ORDER BY caseid, year) foo
	WHERE fvs_econsummary.caseid = foo.caseid AND fvs_econsummary.year = foo.year;


-- take sum of extra harvest costs, undiscounted
UPDATE fvs_compute
SET sk_ct_ex = 0
WHERE sk_ct_ex IS NULL;

UPDATE fvs_compute
SET cb_ct_ex = 0
WHERE cb_ct_ex IS NULL;

UPDATE fvs_compute
SET cb_rg_ex = 0
WHERE cb_rg_ex IS NULL;

UPDATE fvs_compute
SET extra_cost_total = sk_ct_ex + cb_ct_ex + cb_rg_ex;

-- calculate present value of extra harvest costs
UPDATE fvs_compute
SET extra_cost_total_presentvalue = extra_cost_total / ((1+0.05)^(year-2014));

-- calculate cumulative undiscounted extra harvest costs
UPDATE fvs_compute
	SET extra_cost_undiscounted = foo.cum_cost
	FROM (SELECT caseid, year,
		SUM(extra_cost_total) OVER (PARTITION BY caseid ORDER BY year) AS cum_cost
			FROM fvs_compute
		ORDER BY caseid, year) foo
	WHERE fvs_compute.caseid = foo.caseid AND fvs_compute.year = foo.year;

-- calculate cumulative discounted extra harvest costs
UPDATE fvs_compute
	SET extra_cost_discounted = foo.cum_disc_cost
	FROM (SELECT caseid, year,
			SUM(extra_cost_total_presentvalue) OVER (PARTITION BY caseid ORDER BY year) AS cum_disc_cost
			FROM fvs_compute
		ORDER BY caseid, year) foo
	WHERE fvs_compute.caseid = foo.caseid AND fvs_compute.year = foo.year;


--ALTER TABLE fvs_econsummary
--ADD COLUMN total_undiscounted_cost real;

-- calculate ECON costs + extra computed costs, using undiscounted future value
UPDATE fvs_econsummary
SET total_undiscounted_cost = extra.total_cost_undisc
	FROM (SELECT fvs_econsummary.caseid, fvs_econsummary.year, (fvs_compute.extra_cost_undiscounted + fvs_econsummary.undiscounted_cost) AS total_cost_undisc
			FROM fvs_compute, fvs_econsummary
			WHERE fvs_compute.caseid = fvs_econsummary.caseid AND fvs_compute.year = fvs_econsummary.year) extra
	WHERE extra.caseid = fvs_econsummary.caseid AND extra.year = fvs_econsummary.year;


--ALTER TABLE fvs_econsummary
--ADD COLUMN total_discounted cost real;

-- calculate ECON costs + extra computed costs, using present value
UPDATE fvs_econsummary
SET total_discounted_cost = extra.total_cost_disc
	FROM (SELECT fvs_econsummary.caseid, fvs_econsummary.year, (fvs_compute.extra_cost_discounted + fvs_econsummary.discounted_cost) AS total_cost_disc
			FROM fvs_compute, fvs_econsummary
			WHERE fvs_compute.caseid = fvs_econsummary.caseid AND fvs_compute.year = fvs_econsummary.year) extra
	WHERE extra.caseid = fvs_econsummary.caseid AND extra.year = fvs_econsummary.year;
