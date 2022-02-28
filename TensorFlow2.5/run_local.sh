# Start Dockerfil image as a docker container named "mytf2.5", expose port 8888 for 
# jupyter notebook, use all GPU bards.  The container is running on the background
docker run --gpus all -p 8888 --name mytf2.5 tf2.5-build &
