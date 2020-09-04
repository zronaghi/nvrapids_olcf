NUM_WORKERS=6
PACKAGE="dask_cudf"
SCRIPT="cudf_benchmarking_nv.py"
PROJ_ID="gen119"
SCHEDULER_JSON="$MEMBERWORK/$PROJ_ID/dask/my-scheduler-gpu.json"

# I/O - TESTING CHUNKING

#python $SCRIPT --package $PACKAGE --num_dask_workers $NUM_WORKERS --scheduler_json_path $SCHEDULER_JSON --file_size 20G --read_chunk_mb 4096 --stop_at_read True
python $SCRIPT --package $PACKAGE --num_dask_workers $NUM_WORKERS --scheduler_json_path $SCHEDULER_JSON --file_size 25G --stop_at_read True

# Partitioning

python $SCRIPT --package $PACKAGE --num_dask_workers $NUM_WORKERS --scheduler_json_path $SCHEDULER_JSON --file_size 25G

