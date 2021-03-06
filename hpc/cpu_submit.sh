#!/bin/bash
#!
#! Example SLURM job script for Peta4-Skylake (Skylake CPUs, OPA)
#! Last updated: Mon 13 Nov 12:25:17 GMT 2017

#! sbatch directives begin here ###############################
#! Name of the job:
#SBATCH -J bayes-mndo
#! Which project should be charged:
#SBATCH -A LEE-SL3-CPU
#! How many whole nodes should be allocated?
#SBATCH --nodes=1
#! How many (MPI) tasks will there be in total? (<= nodes*32)
#! The skylake/skylake-himem nodes have 32 CPUs (cores) each.
#SBATCH --ntasks=1
#! How much wallclock time will be required?
#SBATCH --time=1:00:00
#! What types of email messages do you wish to receive?
#SBATCH --mail-type=BEGIN,END,FAIL
#! Uncomment this to prevent the job from being requeued (e.g. if
#! interrupted by node failure or system downtime):
##SBATCH --no-requeue

#! For 6GB per CPU, set "-p skylake"; for 12GB per CPU, set "-p skylake-himem": 
#SBATCH -p skylake

#! sbatch directives end here (put any additional directives above this line)

#! Notes:
#! Charging is determined by core number*walltime.
#! The --ntasks value refers to the number of tasks to be launched by SLURM only. This
#! usually equates to the number of MPI tasks launched. Reduce this from nodes*32 if
#! demanded by memory requirements, or if OMP_NUM_THREADS>1.
#! Each task is allocated 1 core by default, and each core is allocated 5990MB (skylake)
#! and 12040MB (skylake-himem). If this is insufficient, also specify
#! --cpus-per-task and/or --mem (the latter specifies MB per node).

#! Modify the settings below to specify the application's environment, location 
#! and launch method:

#! Optionally modify the environment seen by the application
#! (note that SLURM reproduces the environment at submission irrespective of ~/.bashrc):
. /etc/profile.d/modules.sh                # Leave this line (enables the module command)
module purge                               # Removes all modules still loaded
module load rhel7/default-peta4            # REQUIRED - loads the basic environment

#! Insert additional module load commands after this line if needed:

#! Full path to application executable: 
application="python"

#! Run options for the application:
# single job
options="src/scipy_optim"
# array job
# options="-m src.job_array $SLURM_ARRAY_TASK_ID"

CMD="$application $options"

cd $SLURM_SUBMIT_DIR

echo -e "JobID: $SLURM_JOB_ID\n"
echo "Time: `date`"
echo "Running on master node: `hostname`"
echo "Current directory: `pwd`"
echo -e "\nNodes allocated: numtasks=$SLURM_NTASKS, numnodes=$SLURM_JOB_NUM_NODES"
echo -e "\nExecuting command: $CMD\n\n=================="

eval $CMD