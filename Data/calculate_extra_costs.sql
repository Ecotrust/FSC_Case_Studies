--ALTER TABLE fvs_econsummary
--ADD COLUMN cumulative_MBF real;

-- calculate cumulative harvest volume
UPDATE fvs_econsummary
	SET cumulative_MBF = foo.cum_BF/1000.
	FROM (SELECT caseid, year, 
		SUM(mrch_boardfoot_volume) OVER (PARTITION BY caseid ORDER BY year) AS cum_BF
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



--ALTER TABLE fvs_econsummary
--ADD COLUMN npv_total real;

-- calculate total NPV
UPDATE fvs_econsummary
SET npv_total = discounted_revenue - total_discounted_cost;

ALTER TABLE fvs_econsummary
ADD COLUMN nfv_total real;
-- calculate total net future value, undiscounted
UPDATE fvs_econsummary
SET nfv_total = undiscounted_revenue - total_undiscounted_cost;

-- SET npv_total, nfv_total, and cumulative_MBF to zero for pretend harvests
UPDATE fvs_econsummary
SET npv_total = 0,
	nfv_total = 0,
	cumulative_MBF = 0
WHERE fvs_econsummary.pretend_harvest = 'YES';
