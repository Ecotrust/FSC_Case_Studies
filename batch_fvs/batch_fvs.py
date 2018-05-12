import os
import glob
import shutil
import subprocess
import multiprocessing as mp
import tqdm
import time

# gather the list of keyfiles to run
# pulling all keyfiles that were created via "build_keys"
#and are stored in 'keyfiles_to_run'
run_dir = os.path.abspath('keyfiles_to_run/')
to_run = glob.glob(os.path.join(run_dir, '*.key'))
print('{:,}'.format(len(to_run)), 'keyfiles found.')

#tqdm progress bar settings
tasks = range(100)
pbar = tqdm.tqdm(total=len(to_run)/30)

#A function to execute FVS that will be mapped to all keyfiles.
def run_fvs(keyfile):
    cmd = '/usr/local/bin/FVSpnc'
    subprocess.call([cmd, '--keywordfile='+keyfile+' &> out']) # run fvs
    pbar.update(1)

    base_dir = os.path.split(keyfile)[0]
    base_name = os.path.split(keyfile)[-1].split('.')[0]

    # clean-up the outputs
    # move the .out and .key file
    path = os.path.join(base_dir, 'completed','keyfiles')
    if not os.path.exists(path):
        os.makedirs(path)
    shutil.move(keyfile, os.path.join(base_dir,'completed','keyfiles'))
    path = os.path.join(base_dir, 'completed','outfiles')
    if not os.path.exists(path):
        os.makedirs(path)
    shutil.move(os.path.join(base_dir,base_name+'.out'), os.path.join(base_dir,'completed','outfiles'))

     # delete the other files
    try:
        os.remove(os.path.join(base_dir, base_name+'.trl'))
    except OSError:
        pass
    try:
        os.remove(os.path.join(base_dir, base_name+'.txt'))
    except OSError:
        pass

#run fvs on all keyfiles via 'run_fvs' function and  multiprocessing
from multiprocessing import Pool
with Pool(processes=32) as pool:
    pool.imap_unordered(run_fvs, to_run)
    pool.close()
    pool.join()

print ("DONE!")
