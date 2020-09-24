NUM_WORKERS=6
PACKAGE="dask_cudf"
SCRIPT="cudf_benchmarking_nv.py"
PROJ_ID="gen119"
SCHEDULER_JSON="$MEMBERWORK/$PROJ_ID/dask/my-scheduler-gpu.json"
FILE_SIZE="1G 1G 2.5G 5G 10G 25G"

module load gcc/7.4.0
module load cuda/10.1.243
module load python/3.7.0-anaconda3-5.3.0

export CUPY_CACHE_DIR=/gpfs/alpine/scratch/pentschev/gen119/cupy-cache
export PYTHONPATH=$WORLDWORK/gen119/pentschev/nvrapids_0.14_updates
export PATH=$WORLDWORK/stf011/nvrapids_0.14_gcc_7.4.0/bin:$PATH

# allocate batch node before this script: bsub -W 1:00 -nnodes 1 -alloc_flags "NVME" -P gen119 -Is bash
jsrun -n 1 cp -r /gpfs/alpine/world-shared/stf011/somnaths/rapids/data /mnt/bb/$USER/

JSRUN="jsrun -n 1 -c 1 -g 1 --smpiargs='off'"

# I/O - TESTING CHUNKING

$JSRUN python $SCRIPT --package $PACKAGE --num_dask_workers $NUM_WORKERS --scheduler_json_path $SCHEDULER_JSON --file_size $FILE_SIZE --stop_at_read True --persist_instead_of_compute True --auto_chunk_by_num_workers True --auto_chunk_multiplier 1

# Partitioning

if [[ $NUM_WORKERS -eq 1 ]]; then

    FILE_SIZE="1G 1G 2.5G"
    $JSRUN python $SCRIPT --package $PACKAGE --num_dask_workers $NUM_WORKERS --scheduler_json_path $SCHEDULER_JSON --file_size $FILE_SIZE --persist_instead_of_compute True --auto_chunk_by_num_workers True --auto_chunk_multiplier 1

    FILE_SIZE="1G 5G"
    $JSRUN python $SCRIPT --package $PACKAGE --num_dask_workers $NUM_WORKERS --scheduler_json_path $SCHEDULER_JSON --file_size $FILE_SIZE --persist_instead_of_compute True --auto_chunk_by_num_workers True --auto_chunk_multiplier 2

    FILE_SIZE="1G 10G"
    $JSRUN python $SCRIPT --package $PACKAGE --num_dask_workers $NUM_WORKERS --scheduler_json_path $SCHEDULER_JSON --file_size $FILE_SIZE --persist_instead_of_compute True --auto_chunk_by_num_workers True --auto_chunk_multiplier 3

    FILE_SIZE="1G 25G"
    $JSRUN python $SCRIPT --package $PACKAGE --num_dask_workers $NUM_WORKERS --scheduler_json_path $SCHEDULER_JSON --file_size $FILE_SIZE --persist_instead_of_compute True --auto_chunk_by_num_workers True --auto_chunk_multiplier 12

elif [[ $NUM_WORKERS -eq 3 ]]; then

    FILE_SIZE="1G 1G 2.5G 5G 10G"
    $JSRUN python $SCRIPT --package $PACKAGE --num_dask_workers $NUM_WORKERS --scheduler_json_path $SCHEDULER_JSON --file_size $FILE_SIZE --persist_instead_of_compute True --auto_chunk_by_num_workers True --auto_chunk_multiplier 1

    FILE_SIZE="1G 25G"
    $JSRUN python $SCRIPT --package $PACKAGE --num_dask_workers $NUM_WORKERS --scheduler_json_path $SCHEDULER_JSON --file_size $FILE_SIZE --persist_instead_of_compute True --auto_chunk_by_num_workers True --auto_chunk_multiplier 2

else

    $JSRUN python $SCRIPT --package $PACKAGE --num_dask_workers $NUM_WORKERS --scheduler_json_path $SCHEDULER_JSON --file_size $FILE_SIZE --persist_instead_of_compute True --auto_chunk_by_num_workers True --auto_chunk_multiplier 1

fi
