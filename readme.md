### To build the image using docker build command
hostfolder="$(pwd)/app"  
dockerfolder="/opt/spark/work-dir/app"
docker run --rm -it \
  -p 4040:4040 -p 4041:4041 \
  -v ${hostfolder}:${dockerfolder} \
spark3-5-1n:latest
