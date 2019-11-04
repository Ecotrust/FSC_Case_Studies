
# coding: utf-8
# <Construct keyfiles from project directory containing a Base FVS Rx template.

import os
import glob
from jinja2 import Template
import pandas as pd
import random
import time
import tqdm

# Create a jinja2 template from a Base_Rx.key file.
# read in the base_rx keyfile template using jinja2 templating
with open(os.path.join('Rx_Template','Base_Rx.key'), 'r') as base_keyfile:
    template = Template(base_keyfile.read())
    print('Found Base_Rx.key and created jinja2 template.')

# A dictionary for holding the items to insert into an FVS keyfile template using jinja2 templating.
inserts = {}

# Specify the FVS input and output databases for insertion in the jinja2 template
inserts['FVSIn'] = 'FVSIn'
inserts['FVSOut'] = 'FVSOut'

# Look in the Rx_Template directory, add all the kcp files to the `inserts` dictionary.

template_kcps = glob.glob(os.path.join('Rx_Template','*.kcp'))
if len(template_kcps) > 0:
    print('Found the following kcp files in the Rx_Template directory:')
    for kcp in template_kcps:
        fname = os.path.split(kcp)[-1]
        # read the kcp file
        key = fname.split('.')[0] # key for item in inserts dictionary
        with open(kcp, 'r') as item:
            value = item.read()
        # add the contents of the kcp file to the inserts dictionary
        inserts[key] = value
        print(' added to template.')
else:
    raise FileNotFoundError('No kcp files found in the Rx_Template directory.')

# Gather variant-specific KCP files for SDImax and Log_Values

SDImax_dict = {} # variant: SDImax keywords
logvalue_dict = {} # variant: log value specs

variant_kcps = glob.glob(os.path.join('Rx_Template','variant_specific_kcps','*.kcp'))
if len(variant_kcps) > 0:
    print('Found the following kcp files in the variant_specific_kcps directory:')
    for kcp in variant_kcps:
        fname = os.path.split(kcp)[-1]
        variant = fname.split('.')[0][-2:]
        kcp_type = fname.split('.')[0][:-3]
        print(variant, kcp_type)
        # read the kcp file
        with open(kcp, 'r') as item:
            key = variant
            value = item.read()
        if kcp_type == 'SDImax':
            SDImax_dict[key] = value
        elif kcp_type == 'logvalue':
            logvalue_dict[key] = value
        print(' added to template.')
else:
    raise FileNotFoundError('No kcp files found in the variant_specific_kcps directory.')

# Define Soil Expectation Values for Flat Ground and Steep Ground
sev_lookup = {
    'sev_flat':{
        50:1, 55:1, 60:1, 65:1, 70:1, 75:1, 80:1, 85:1,
        90:1, 95:1814, 100:2283, 105:2463, 110:2681, 115:3568, 120:3950, 125:4024,
        130:4137, 135:4358, 140:4827, 145:5044, 150:5211, 155:5206, 160:5598
                },
    'sev_steep':{
        50:1, 55:1, 60:1, 65:1, 70:1, 75:1, 80:1, 85:1,
        90:1, 95:1388, 100:1701, 105:1942, 110:2102, 115:2870, 120:3069, 125:3326,
        130:3406, 135:3761, 140:3870, 145:4185, 150:4172, 155:4159, 160:4540
                }
        }

rxs_dict = {}
# a dictionary storing the silvicultural keywords for each rx
rx_kcps = glob.glob(os.path.join('Rx_Template', 'Rxs', 'rx*.kcp'))
if len(rx_kcps) > 0:
    print('Found the following kcp files in the Rxs subdirectory:')
    for kcp in rx_kcps:
        fname = os.path.split(kcp)[-1]
        print(fname)
        # read the kcp file
        key = fname.split('/')[-1].split('.')[0] # key for item in inserts dictionary
        with open(kcp, 'r') as item:
            value = item.read()
        # add the contents of the kcp file to the inserts dictionary
        rxs_dict[key] = value
        print(' added to template.')
else:
    raise FileNotFoundError('No kcp files found in the Rx_Template directory.')

# A function to use for creating keyfiles.

def create_keyfile(standID, variant, site_index, slope, convyr, rx):
    '''
    Creates a single FVS keyfile based on the jinja2 template.
    '''
    inserts['ID'] = standID
    inserts['SDImax'] = SDImax_dict[variant]
    inserts['Log_Value'] = logvalue_dict[variant]
    inserts['rx'] = rxs_dict[rx]
    inserts['site_index'] = site_index
    inserts['variant'] = variant
    inserts['convyr'] = convyr
    # lookup the soil expectation value for steep or flat slopes
    # round the stand's site index down the nearest multiple of 5
    inserts['sev'] = sev_lookup['sev_steep' if slope > 35 else 'sev_flat'][site_index//5 * 5]


    fname = 'fvs'+variant+'_stand'+str(standID)+'_'+rx+'_SI'+str(site_index)+'_off'+'.key'

    path = os.path.abspath('keyfiles_to_run')
    if not os.path.exists(path):
        os.makedirs(path)
    with open(os.path.join('keyfiles_to_run',fname),'w') as keyfile:
        keyfile.write(template.render(**inserts))

# Identify stands to run.

# option to import from CSV file with standID and variant
#stands = pd.read_csv(os.path.join('Data','Outer.csv'))
#stands.head()

# Import from postgres input database
import psycopg2

conn = psycopg2.connect("dbname='FVSIn' user='ubuntu' host='localhost'") # password in pgpass file

SQL = '''
SELECT stand_id, variant, site_index, slope, convyr
FROM stand_init;
'''
# read the query into a pandas dataframe
stands = pd.read_sql(SQL, conn)

# close the database connection
conn.close()

#read in stands dataframe as a list of tuples
#to be run through create_keyfile
values=list(stands.itertuples(index=False, name=None))

#specify what rxs you want to rxs_to_run
rxs_to_run = ['rx2Fm', 'rx2Fs', 'rx2Nl', 'rx2Nm', 'rx2Ns', 'rx2Sm', 'rx2Ss', 'rx2WA',
'rx5Fl', 'rx5Fm', 'rx5Fs', 'rx5Nl', 'rx5Nm', 'rx5Ns', 'rx5Sm', 'rx5Ss', 'rx5WA']


to_build=[]
#add these rx combinations to our list of keyfiles to create
for rx in rxs_to_run:
    for i in values:
        to_build.append(list(i)+[rx])
print (to_build)

#count and print the number of stand/rx combinations are going to be created
cnt=len(to_build)
print("Number of keyfiles to be built:")
print(cnt)

#create keyfiles based on site index of stand!
#with progress bar
for item in tqdm.tqdm(iterable=to_build, total=cnt):
    if int(item[2]) >= 115:
        sdi_max = 550
        bai_mult = 0.5
        inserts['sdi_max'] = sdi_max
        inserts['bai_mult'] = bai_mult
        create_keyfile(*item)
    elif int(item[2]) >= 95:
        sdi_max = 450
        bai_mult = 0.5
        inserts['sdi_max'] = sdi_max
        inserts['bai_mult'] = bai_mult
        create_keyfile(*item)
    elif int(item[2]) < 95:
        sdi_max = 450
        bai_mult = 0.3
        inserts['sdi_max'] = sdi_max
        inserts['bai_mult'] = bai_mult
        create_keyfile(*item)
