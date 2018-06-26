# SQL Statements for Creating FVS Output Database Tables
# =============================================================================
# The queries have been slightly amended from default FVS code for PostgreSQL
# databases. The changes were limited to changing char variables to varchar and
# removing null declarations, as PostgreSQL allows null values for columns by
# default.
#
# The queries below also include the creation of views and database rules to
# redirect FVS outputs from views to underlying data tables. This was designed
# as a workaround to a slowdown during long batch runs apparently related to
# FVS source code using a SELECT * FROM ... statement to confirm whether the
# target database table exists every time before it writes to the database.
# These will, for example, allow FVS to see 'fvs_summary' and attempt to write
# to it. The database will redirect FVS INSERT queries from the 'fvs_summary'
# view to the underlying 'summary' database table. Your FVS output data will
# thus live in database tables without the 'fvs_' prefix.
#
# The named strings for each CREATE TABLE query can also be
# pulled into a separate script for execution.
#
# The FVS_DM_Sz_Sum table is incompatible with PostgreSQL conventions (column
# names beginning with numbers) and is not included here.
#
# Only tables relevant to western FVS variants are included (e.g.,
# FVS_Summary_East and FVS_PotFire_East have not been included).

# from fvs\code\dbs\src\dbsatrtls.f
fvs_atrtlist = '''
CREATE TABLE atrtlist (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
prdlen int,
treeid varchar(8),
treeindex int,
species varchar(3),
treeval int,
sscd int,
ptindex int,
tpa real,
mortpa real,
dbh real,
dg real,
ht real,
htg real,
pctcr int,
crwidth real,
mistcd int,
bapctile real,
ptbal real,
tcuft real,
mcuft real,
bdft real,
mdefect int,
bdefect int,
truncht int,
estht real,
actpt int,
ht2tdcf real,
ht2tdbf real,
treeage real
);

CREATE VIEW fvs_atrtlist AS
SELECT * FROM atrtlist LIMIT 0;

CREATE RULE redirect_atrtlist AS
ON INSERT TO fvs_atrtlist
DO INSTEAD INSERT INTO atrtlist VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsbmbkp.f
fvs_bm_bkp = '''
CREATE TABLE bm_bkp (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
oldbkp real,
newbkp real,
selfbkp real,
to_ls real,
frm_ls real,
in_ow real,
out2ow real,
per_surv real,
strpbkp real,
strp_sc real,
rembkp real,
rv real,
dvrv1 real,
dvrv2 real,
dvrv3 real,
dvrv4 real,
dvrv5 real,
dvrv6 real,
dvrv7 real,
dvrv8 real,
dvrv9 real,
tpafast real,
bafast real,
volfast real
);

CREATE VIEW fvs_bm_bkp AS
SELECT * FROM bm_bkp LIMIT 0;

CREATE RULE redirect_bm_bkp AS
ON INSERT TO fvs_bm_bkp
DO INSTEAD INSERT INTO bm_bkp VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsbmmain.f
fvs_bm_main = '''
CREATE TABLE bm_main (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
predispbkp real,
postdispbkp real,
standrv real,
standba real,
bah real,
ba_btlkld real,
tpa real,
tpah real,
tpa_btlkld real,
standvol real,
volhost real,
volbtlkld real,
ba_special real,
ips_slash real,
ba_san_remv real,
bkp_san_remv real,
tpa_sanremvlv real,
tpa_sanremlvdd real,
volremsan real,
volremsalv real
);

CREATE VIEW fvs_bm_main AS
SELECT * FROM bm_main LIMIT 0;

CREATE RULE redirect_bm_main AS
ON INSERT TO fvs_bm_main
DO INSTEAD INSERT INTO bm_main VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsbmtree.f
fvs_bm_tree = '''
CREATE TABLE bm_tree (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
tpa_sc1 real,
tpa_sc2 real,
tpa_sc3 real,
tpa_sc4 real,
tpa_sc5 real,
tpa_sc6 real,
tpa_sc7 real,
tpa_sc8 real,
tpa_sc9 real,
tpa_10 real,
host1 real,
host2 real,
host3 real,
host4 real,
host5 real,
host6 real,
host7 real,
host8 real,
host9 real,
host10 real,
tkld1 real,
tkld2 real,
tkld3 real,
tkld4 real,
tkld5 real,
tkld6 real,
tkld7 real,
tkld8 real,
tkld9 real,
tkld10 real,
spcl1 real,
spcl2 real,
spcl3 real,
spcl4 real,
spcl5 real,
spcl6 real,
spcl7 real,
spcl8 real,
spcl9 real,
spcl10 real,
san1 real,
san2 real,
san3 real,
san4 real,
san5 real,
san6 real,
san7 real,
san8 real,
san9 real,
san10 real
);

CREATE VIEW fvs_bm_tree AS
SELECT * FROM bm_tree LIMIT 0;

CREATE RULE redirect_bm_tree AS
ON INSERT TO fvs_bm_tree
DO INSTEAD INSERT INTO bm_tree VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsbmvol.f
fvs_bm_vol = '''
CREATE TABLE bm_vol (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
tv_sc1 real,
tv_sc2 real,
tv_sc3 real,
tv_sc4 real,
tv_sc5 real,
tv_sc6 real,
tv_sc7 real,
tv_sc8 real,
tv_sc9 real,
tv_10 real,
hv_sc1 real,
hv_sc2 real,
hv_sc3 real,
hv_sc4 real,
hv_sc5 real,
hv_sc6 real,
hv_sc7 real,
hv_sc8 real,
hv_sc9 real,
hv_10 real,
vk_sc1 real,
vk_sc2 real,
vk_sc3 real,
vk_sc4 real,
vk_sc5 real,
vk_sc6 real,
vk_sc7 real,
vk_sc8 real,
vk_sc9 real,
vk_10 real
);

CREATE VIEW fvs_bm_vol AS
SELECT * FROM bm_vol LIMIT 0;

CREATE RULE redirect_bm_vol AS
ON INSERT TO fvs_bm_vol
DO INSTEAD INSERT INTO bm_vol VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbscase.f
fvs_cases = '''
CREATE TABLE cases (
caseid varchar(36) not null,
stand_cn varchar(40),
standid varchar(26),
mgmtid varchar(4),
runtitle varchar(72),
keywordfile varchar(50),
samplingwt real,
variant varchar(2),
version varchar(10),
rv varchar(8),
groups varchar(250),
rundatetime varchar(19)
);

CREATE VIEW fvs_cases AS
SELECT * FROM cases LIMIT 0;

CREATE RULE redirect_cases AS
ON INSERT TO fvs_cases
DO INSTEAD INSERT INTO cases VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsclsum.f
fvs_climate = '''
CREATE TABLE climate (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
species varchar(3),
viability real,
ba real,
tpa real,
viabmort real,
dclimmort real,
growthmult real,
sitemult real,
mxdenmult real,
autoestbtpa real
);

CREATE VIEW fvs_climate AS
SELECT * FROM climate LIMIT 0;

CREATE RULE redirect_climate AS
ON INSERT TO fvs_climate
DO INSTEAD INSERT INTO climate VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbscuts.f
fvs_cutlist = '''
CREATE TABLE cutlist (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
prdlen int,
treeid varchar(8),
treeindex int,
species varchar(3),
treeval int,
sscd int,
ptindex int,
tpa real,
mortpa real,
dbh real,
dg real,
ht real,
htg real,
pctcr int,
crwidth real,
mistcd int,
bapctile real,
ptbal real,
tcuft real,
mcuft real,
bdft real,
mdefect int,
bdefect int,
truncht int,
estht real,
actpt int,
ht2tdcf real,
ht2tdbf real,
treeage real
);

CREATE VIEW fvs_cutlist AS
SELECT * FROM cutlist LIMIT 0;

CREATE RULE redirect_cutlist AS
ON INSERT TO fvs_cutlist
DO INSTEAD INSERT INTO cutlist VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbseconhrv.f
fvs_econharvestvalue = '''
CREATE TABLE econharvestvalue (
caseid varchar(36) not null,
year int,
species varchar(8),
min_dib real,
max_dib real,
min_dbh real,
max_dbh real,
tpa_removed int,
tpa_value int,
tons_per_acre int,
ft3_removed int,
ft3_value int,
board_ft_removed int,
board_ft_value int,
total_value int
);

CREATE VIEW fvs_econharvestvalue AS
SELECT * FROM econharvestvalue LIMIT 0;

CREATE RULE redirect_econharvestvalue AS
ON INSERT TO fvs_econharvestvalue
DO INSTEAD INSERT INTO econharvestvalue VALUES (NEW.*);
'''
# from fvs\code\dbs\src\dbsecsum.f
fvs_econsummary = '''
CREATE TABLE econsummary (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
period int,
pretend_harvest varchar(3),
undiscounted_cost real,
undiscounted_revenue real,
discounted_cost real,
discounted_revenue real,
pnv real,
irr real,
bc_ratio real,
rrr real,
sev real,
value_of_forest real,
value_of_trees real,
mrch_cubic_volume int,
mrch_boardfoot_volume int,
discount_rate real,
given_sev real
);

CREATE VIEW fvs_econsummary AS
SELECT * FROM econsummary LIMIT 0;

CREATE RULE redirect_econsummary AS
ON INSERT TO fvs_econsummary
DO INSTEAD INSERT INTO econsummary VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsfmburn.f
fvs_burnreport = '''
CREATE TABLE burnreport (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
one_hr_moisture real,
ten_hr_moisture real,
hundred_hr_moisture real,
thousand_hr_moisture real,
duff_moisture real,
live_woody_moisture real,
live_herb_moisture real,
midflame_wind real,
slope real,
flame_length real,
scorch_height real,
fire_type varchar(8),
fuelmodl1 real,
weight1 real,
fuelmodl2 real,
weight2 real,
fuelmodl3 real,
weight3 real,
fuelmodl4 real,
weight4 real
);

CREATE VIEW fvs_burnreport AS
SELECT * FROM burnreport LIMIT 0;

CREATE RULE redirect_burnreport AS
ON INSERT TO fvs_burnreport
DO INSTEAD INSERT INTO burnreport VALUES (NEW.*);
'''
# from fvs\code\dbs\src\dbsfmcanpr.f
fvs_canprofile = '''
CREATE TABLE canprofile (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
height_m real,
canopy_fuel_kg_m3 real,
height_ft real,
canopy_fuel_lbs_acre_ft real
);

CREATE VIEW fvs_canprofile AS
SELECT * FROM canprofile LIMIT 0;

CREATE RULE redirect_canprofile AS
ON INSERT TO fvs_canprofile
DO INSTEAD INSERT INTO canprofile VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsfmcrpt.f
fvs_carbon = '''
CREATE TABLE carbon (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
aboveground_total_live real,
aboveground_merch_live real,
belowground_live real,
belowground_dead real,
standing_dead real,
forest_down_dead_wood real,
forest_floor real,
forest_shrub_herb real,
total_stand_carbon real,
total_removed_carbon real,
carbon_released_from_fire real
);

CREATE VIEW fvs_carbon AS
SELECT * FROM carbon LIMIT 0;

CREATE RULE redirect_carbon AS
ON INSERT TO fvs_carbon
DO INSTEAD INSERT INTO carbon VALUES (NEW.*);
'''
# from fvs\code\dbs\src\dbsfmdsnag.f
fvs_snagdet = '''
CREATE TABLE snagdet (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
species varchar(3),
dbh_class int,
death_dbh real,
current_ht_hard real,
current_ht_soft real,
current_vol_hard real,
current_vol_soft real,
total_volume real,
year_died int,
density_hard real,
density_soft real,
density_total real
);

CREATE VIEW fvs_snagdet AS
SELECT * FROM snagdet LIMIT 0;

CREATE RULE redirect_snagdet AS
ON INSERT TO fvs_snagdet
DO INSTEAD INSERT INTO snagdet VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsfmdwcov.f
fvs_down_wood_cov = '''
CREATE TABLE down_wood_cov (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
dwd_cover_3to6_hard real,
dwd_cover_6to12_hard real,
dwd_cover_12to20_hard real,
dwd_cover_20to35_hard real,
dwd_cover_35to50_hard real,
dwd_cover_ge_50_hard real,
dwd_cover_total_hard real,
dwd_cover_3to6_soft real,
dwd_cover_6to12_soft real,
dwd_cover_12to20_soft real,
dwd_cover_20to35_soft real,
dwd_cover_35to50_soft real,
dwd_cover_ge_50_soft real,
dwd_cover_total_soft real
);

CREATE VIEW fvs_down_wood_cov AS
SELECT * FROM down_wood_cov LIMIT 0;

CREATE RULE redirect_down_wood_cov AS
ON INSERT TO fvs_down_wood_cov
DO INSTEAD INSERT INTO down_wood_cov VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsfmdwvol.f
fvs_down_wood_vol = '''
CREATE TABLE down_wood_vol (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
dwd_volume_0to3_hard real,
dwd_volume_3to6_hard real,
dwd_volume_6to12_hard real,
dwd_volume_12to20_hard real,
dwd_volume_20to35_hard real,
dwd_volume_35to50_hard real,
dwd_volume_ge_50_hard real,
dwd_volume_total_hard real,
dwd_volume_0to3_soft real,
dwd_volume_3to6_soft real,
dwd_volume_6to12_soft real,
dwd_volume_12to20_soft real,
dwd_volume_20to35_soft real,
dwd_volume_35to50_soft real,
dwd_volume_ge_50_soft real,
dwd_volume_total_soft real
);

CREATE VIEW fvs_down_wood_vol AS
SELECT * FROM down_wood_vol LIMIT 0;

CREATE RULE redirect_down_wood_vol AS
ON INSERT TO fvs_down_wood_vol
DO INSTEAD INSERT INTO down_wood_vol VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsfmfuel.f
fvs_consumption = '''
CREATE TABLE consumption (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
min_soil_exp real,
litter_consumption real,
duff_consumption real,
consumption_lt3 real,
consumption_ge3 real,
consumption_3to6 real,
consumption_6to12 real,
consumption_ge12 real,
consumption_herb_shrub real,
consumption_crowns real,
total_consumption real,
percent_consumption_duff real,
percent_consumption_ge3 real,
percent_trees_crowning real,
smoke_production_25 real,
smoke_production_10 real
);

CREATE VIEW fvs_consumption AS
SELECT * FROM consumption LIMIT 0;

CREATE RULE redirect_consumption AS
ON INSERT TO fvs_consumption
DO INSTEAD INSERT INTO consumption VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsfmhrpt.f
fvs_hrv_carbon = '''
CREATE TABLE hrv_carbon (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
products real,
landfill real,
energy real,
emissions real,
merch_carbon_stored real,
merch_carbon_removed real
);

CREATE VIEW fvs_hrv_carbon AS
SELECT * FROM hrv_carbon LIMIT 0;

CREATE RULE redirect_hrv_carbon AS
ON INSERT TO fvs_hrv_carbon
DO INSTEAD INSERT INTO hrv_carbon VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsfmmort.f
fvs_mortality = '''
CREATE TABLE mortality (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
species varchar(3),
killed_class1 real,
total_class1 real,
killed_class2 real,
total_class2 real,
killed_class3 real,
total_class3 real,
killed_class4 real,
total_class4 real,
killed_class5 real,
total_class5 real,
killed_class6 real,
total_class6 real,
killed_class7 real,
total_class7 real,
bakill real,
volkill real
);

CREATE VIEW fvs_mortality AS
SELECT * FROM mortality LIMIT 0;

CREATE RULE redirect_mortality AS
ON INSERT TO fvs_mortality
DO INSTEAD INSERT INTO mortality VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsfmpf.f
fvs_potfire = '''
CREATE TABLE potfire (
caseid varchar(36) not null,
standid varchar(26) ,
year int,
surf_flame_sev real,
surf_flame_mod real,
tot_flame_sev real,
tot_flame_mod real,
fire_type_sev varchar(8),
fire_type_mod varchar(8),
ptorch_sev real,
ptorch_mod real,
torch_index real,
crown_index real,
canopy_ht real,
canopy_density real,
mortality_ba_sev real,
mortality_ba_mod real,
mortality_vol_sev real,
mortality_vol_mod real,
pot_smoke_sev real,
pot_smoke_mod real,
fuel_mod1 real,
fuel_mod2 real,
fuel_mod3 real,
fuel_mod4 real,
fuel_wt1 real,
fuel_wt2 real,
fuel_wt3 real,
fuel_wt4 real
);

CREATE VIEW fvs_potfire AS
SELECT * FROM potfire LIMIT 0;

CREATE RULE redirect_potfire AS
ON INSERT TO fvs_potfire
DO INSTEAD INSERT INTO potfire VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsfmssnag.f
fvs_snagsum = '''
CREATE TABLE snagsum (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
hard_snags_class1 real,
hard_snags_class2 real,
hard_snags_class3 real,
hard_snags_class4 real,
hard_snags_class5 real,
hard_snags_class6 real,
hard_snags_total real,
soft_snags_class1 real,
soft_snags_class2 real,
soft_snags_class3 real,
soft_snags_class4 real,
soft_snags_class5 real,
soft_snags_class6 real,
soft_snags_total real,
hard_soft_snags_total real
);

CREATE VIEW fvs_snagsum AS
SELECT * FROM snagsum LIMIT 0;

CREATE RULE redirect_snagsum AS
ON INSERT TO fvs_snagsum
DO INSTEAD INSERT INTO snagsum VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsfuels.f
fvs_fuels = '''
CREATE TABLE fuels (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
surface_litter real,
surface_duff real,
surface_lt3 real,
surface_ge3 real,
surface_3to6 real,
surface_6to12 real,
surface_ge12 real,
surface_herb real,
surface_shrub real,
surface_total real,
standing_snag_lt3 real,
standing_snag_ge3 real,
standing_foliage real,
standing_live_lt3 real,
standing_live_ge3 real,
standing_total real,
total_biomass int,
total_consumed int,
biomass_removed int
);

CREATE VIEW fvs_fuels AS
SELECT * FROM fuels LIMIT 0;

CREATE RULE redirect_fuels AS
ON INSERT TO fvs_fuels
DO INSTEAD INSERT INTO fuels VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsmis.f
fvs_dm_spp_sum = '''
CREATE TABLE dm_spp_sum (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
spp varchar(2),
mean_dmr real,
mean_dmi real,
inf_tpa int,
mort_tpa int,
inf_tpa_pct int,
mort_tpa_pct int,
stnd_tpa_pct int
);

CREATE VIEW fvs_dm_spp_sum AS
SELECT * FROM dm_spp_sum LIMIT 0;

CREATE RULE redirect_dm_spp_sum AS
ON INSERT TO fvs_dm_spp_sum
DO INSTEAD INSERT INTO dm_spp_sum VALUES (NEW.*);
'''

fvs_dm_stnd_sum = '''
CREATE TABLE dm_stnd_sum (
caseid varchar(26) not null,
standid varchar(26) not null,
year int,
age int,
stnd_tpa int,
stnd_ba int,
stnd_vol int,
inf_tpa int,
inf_ba int,
inf_vol int,
mort_tpa int,
mort_ba int,
mort_vol int,
inf_tpa_pct int,
inf_vol_pct int,
mort_tpa_pct int,
mort_vol_pct int,
mean_dmr real,
mean_dmi real
);

CREATE VIEW fvs_dm_stnd_sum AS
SELECT * FROM dm_stnd_sum LIMIT 0;

CREATE RULE redirect_dm_stnd_sum AS
ON INSERT TO fvs_dm_stnd_sum
DO INSTEAD INSERT INTO dm_stnd_sum VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsrd.f
fvs_rd_sum = '''
CREATE TABLE rd_sum (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
age int,
rd_type varchar(1),
num_centers int,
rd_area real,
spread_ft_per_year real,
stumps_per_acre real,
stumps_ba real,
mort_tpa real,
mort_cuft real,
uninf_tpa real,
inf_tpa real,
ave_pct_root_inf real,
live_merch_cuft real,
live_ba real,
new_inf_prp_ins real,
new_inf_prp_exp real,
new_inf_prp_tot real
);

CREATE VIEW fvs_rd_sum AS
SELECT * FROM rd_sum LIMIT 0;

CREATE RULE redirect_rd_sum AS
ON INSERT TO fvs_rd_sum
DO INSTEAD INSERT INTO rd_sum VALUES (NEW.*);
'''

fvs_rd_det = '''
CREATE TABLE rd_det (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
rd_type varchar(1) not null,
rd_area real,
species varchar(2) not null,
mort_10pctile_dbh real,
mort_30pctile_dbh real,
mort_50pctile_dbh real,
mort_70pctile_dbh real,
mort_90pctile_dbh real,
mort_100pctile_dbh real,
mort_tpa_total real,
live_10pctile_dbh real,
live_30pctile_dbh real,
live_50pctile_dbh real,
live_70pctile_dbh real,
live_90pctile_dbh real,
live_100pctile_dbh real,
uninf_tpa_total real,
inf_tpa_total real,
pct_roots_inf real
);

CREATE VIEW fvs_rd_det AS
SELECT * FROM rd_det LIMIT 0;

CREATE RULE redirect_rd_det AS
ON INSERT TO fvs_rd_det
DO INSTEAD INSERT INTO rd_det VALUES (NEW.*);
'''

fvs_rd_beetle = '''
CREATE TABLE rd_beetle (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
species varchar(2) not null,
in_inf_0_5_dbh real,
in_inf_5_10_dbh real,
in_inf_10_15_dbh real,
in_inf_15_20_dbh real,
in_inf_20_25_dbh real,
in_inf_25_30_dbh real,
in_inf_30_dbh real,
in_inf_mort real,
in_inf_live_before real,
in_uninf_0_5_dbh real,
in_uninf_5_10_dbh real,
in_uninf_10_15_dbh real,
in_uninf_15_20_dbh real,
in_uninf_20_25_dbh real,
in_uninf_25_30_dbh real,
in_uninf_30_dbh real,
in_uninf_mort real,
in_uninf_live_before real,
outside_0_5_dbh real,
outside_5_10_dbh real,
outside_10_15_dbh real,
outside_15_20_dbh real,
outside_20_25_dbh real,
outside_25_30_dbh real,
outside_30_dbh real,
outside_mort real,
outside_live_before real,
stand_mort_total real
);

CREATE VIEW fvs_rd_beetle AS
SELECT * FROM rd_beetle LIMIT 0;

CREATE RULE redirect_rd_beetle AS
ON INSERT TO fvs_rd_beetle
DO INSTEAD INSERT INTO rd_beetle VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbsstrclass.f
fvs_strclass = '''
CREATE TABLE strclass (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
removal_code real,
stratum_1_dbh real,
stratum_1_nom_ht real,
stratum_1_lg_ht real,
stratum_1_sm_ht real,
stratum_1_crown_base real,
stratum_1_crown_cover real,
stratum_1_species_1 varchar(3),
stratum_1_species_2 varchar(3),
stratum_1_status_code real,
stratum_2_dbh real,
stratum_2_nom_ht real,
stratum_2_lg_ht real,
stratum_2_sm_ht real,
stratum_2_crown_base real,
stratum_2_crown_cover real,
stratum_2_species_1 varchar(3),
stratum_2_species_2 varchar(3),
stratum_2_status_code real,
stratum_3_dbh real,
stratum_3_nom_ht real,
stratum_3_lg_ht real,
stratum_3_sm_ht real,
stratum_3_crown_base real,
stratum_3_crown_cover real,
stratum_3_species_1 varchar(3),
stratum_3_species_2 varchar(3),
stratum_3_status_code real,
number_of_strata real,
total_cover real,
structure_class varchar(4)
PRIMARY KEY (caseid, year)
);

CREATE VIEW fvs_strclass AS
SELECT * FROM strclass LIMIT 0;

CREATE RULE redirect_strclass AS
ON INSERT TO fvs_strclass
DO INSTEAD INSERT INTO strclass VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbssumry.f
fvs_summary = '''
CREATE TABLE summary (
caseid varchar(36),
standid varchar(26),
year int,
age int,
tpa real,
ba real,
sdi real,
ccf real,
topht real,
qmd real,
tcuft real,
mcuft real,
bdft real,
rtpa real,
rtcuft real,
rmcuft real,
rbdft real,
atba real,
atsdi real,
atccf real,
attopht real,
atqmd real,
prdlen int,
acc real,
mort real,
mai real,
fortyp int,
sizecls int,
stkcls int
);

CREATE VIEW fvs_summary AS
SELECT * FROM summary LIMIT 0;

CREATE RULE redirect_summary AS
ON INSERT TO fvs_summary
DO INSTEAD INSERT INTO summary VALUES (NEW.*);
'''

# from fvs\code\dbs\src\dbstrls.f
fvs_treelist = '''
CREATE TABLE treelist (
caseid varchar(36) not null,
standid varchar(26) not null,
year int,
prdlen int,
treeid varchar(8),
treeindex int,
species varchar(8),
treeval int,
sscd int,
ptindex int,
tpa real,
mortpa real,
dbh real,
dg real,
ht real,
htg real,
pctcr int,
crwidth real,
mistcd int,
bapctile real,
ptbal real,
tcuft real,
mcuft real,
bdft real,
mdefect int,
bdefect int,
truncht int,
estht real,
actpt int,
ht2tdcf real,
ht2tdbf real,
treeage real
);

CREATE VIEW fvs_treelist AS
SELECT * FROM treelist LIMIT 0;

CREATE RULE redirect_treelist AS
ON INSERT TO fvs_treelist
DO INSTEAD INSERT INTO treelist VALUES (NEW.*);
'''
