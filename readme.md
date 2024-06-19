### To build the image using docker build command
hostfolder="$(pwd)/app"  
dockerfolder="/opt/spark/work-dir/app"
docker run --rm -it \
  -p 4040:4040 -p 4041:4041 \
  -v ${hostfolder}:${dockerfolder} \
spark3-5-1n:latest

In above command 
--rm means that remove the container if it exists.
-it means run the container in interactive mode with TTY allocated. 
-t attach a tag/name to the image. 
-d means detached mode
-p means port mapping
-v means volume mapping. 

To run detached from current terminal window use -d flag:

```bash
docker run -d --rm -it \
    -p 4040:4040 -v ${hostfolder}/app:${dockerfolder} \ 
    docker-spark-single-node:latest
```