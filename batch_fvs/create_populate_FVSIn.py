import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

#Create FVSIn database

#conn = psycopg2.connect("dbname='postgres' user='postgres' host='localhost'") # password stored in pgpass
#conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
#cur = conn.cursor()

#cur.execute('CREATE DATABASE "FVSIn"')
#conn.close()

#create connection to FVSIn
conn = psycopg2.connect("dbname='FVSIn' user='ubuntu' host='localhost'")

#create blank standinit table
with conn:
    with conn.cursor() as cur:
        SQL = '''
        CREATE TABLE stand_init (
        stand_cn varchar(40),
        stand_id varchar(26) not null PRIMARY KEY,
        variant varchar(11) not null,
        inv_year int not null,
        groups text,
        addfiles text,
        fvskeywords text,
        latitude double precision,
        longitude double precision,
        region int,
        forest int,
        district int,
        compartment int,
        location int,
        ecoregion varchar(6),
        pv_code varchar(10),
        pv_ref_code int,
        age int,
        aspect double precision,
        slope double precision,
        elevation int,
        elevft double precision,
        basal_area_factor double precision not null,
        inv_plot_size double precision not null,
        brk_dbh double precision not null,
        num_plots int,
        nonstk_plots int,
        sam_w double precision,
        stk_pcnt double precision,
        dg_trans int,
        dg_measure int,
        htg_trans int,
        htg_measure int,
        mort_measure int,
        max_ba double precision,
        max_sdi double precision,
        site_species varchar(8),
        site_index double precision,
        model_type int,
        physio_region int,
        forest_type int,
        county int,
        fuel_model int,
        fuel_0_25 double precision,
        fuel_25_1 double precision,
        fuel_0_1 double precision,
        fuel_1_3 double precision,
        fuel_3_6 double precision,
        fuel_6_12 double precision,
        fuel_gt_12 double precision,
        fuel_litter double precision,
        fuel_duff double precision,
        photo_ref int,
        photo_code varchar(13),
        gis_id int,
        state text,
        streamType text,
        streamSize text
        );
        '''
        cur.execute(SQL)

#create empty treeinit table
with conn:
    with conn.cursor() as cur:
        SQL = '''
        CREATE TABLE tree_init (
       stand_cn varchar(40),
        stand_id varchar(26), 
        plot_id varchar(26) not null,
        tree_id int not null,
        tree_count double precision,
        history int,
        species varchar(8) not null,
        dbh double precision not null,
        dg double precision,
        ht double precision,
        htg double precision,
        httopk double precision,
        crratio double precision,
        damage1 int,
        severity1 double precision,
        damage2 int,
        severity2 double precision,
        damage3 int,
        severity3 double precision,
        treevalue int,
        prescription double precision,
        age int
        );
        '''
        cur.execute(SQL)

conn.close()
