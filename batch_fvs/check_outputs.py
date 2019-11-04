import psycopg2
import pandas as pd
import os
import glob

#set up connection with FVSout DATABASE
#read in number of completed stands by mgmtid
conn = psycopg2.connect("dbname='FVSOut' user='ubuntu' host='localhost'")
SQL = '''
SELECT keywordfile, caseid, mgmtid
FROM fvs_cases;
'''
# read the query into a pandas dataframe
completed = pd.read_sql(SQL, conn)

# close the database connection
conn.close()

#print the completed number of unique cases
completed_num = len(pd.unique(completed.caseid))
print('{:,}'.format(len(completed)), 'unique runs.')

#grab names of completed keyfiles
completed['keyfile'] = completed.keywordfile.apply(lambda x: os.path.split(x)[-1] + '.key')
completed_keys = glob.glob('/storage/FSC_Case_Studies/keyfiles_to_run/completed/keyfiles/*.key')

#compare run keyfiles with records in database
run_dir = os.path.abspath('keyfiles_to_run/')
completed_basenames = [os.path.split(x)[-1] for x in completed_keys]
print(len(completed), 'keyfiles in database')
print(len(completed_basenames), 'keyfiles in completed folder')

#find the keyfiles that did not get run
for keyfile in completed.keyfile.values: # keyfiles recorded in the DB
    if keyfile not in completed_basenames:
        print(keyfile)

for keyfile in completed_basenames: # keyfiles recorded in the DB
    if keyfile not in completed.keyfile.values: # keyfiles moved into output folder
        print(keyfile)
