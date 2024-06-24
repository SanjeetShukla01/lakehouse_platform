### To build the image using docker build command
```bash
docker build -t spark3-5-1n .
```
Or for more verbose build
```bash
docker build -t spark3-5-1n . --progress=plain
```
With given dockerfile
```bash
docker build -t spark-delta:latest -f Dockerfile .
```

### To inspect image for any issue:
`docker inspect spark3-5-1n:latest`


`docker run -it spark3-5-1n:latest /opt/spark/bin/spark-shell`

`docker run -d spark3-5-1n:latest tail -f /dev/null`
` docker exec -it 649f88bd0e30 bash`
`/opt/spark/bin/spark-shell`



### To run the container from image built in above step. 
```bash
hostfolder="$(pwd)/app"  
dockerfolder="/opt/spark/work-dir/app"
docker run --rm -it \
  -p 4040:4040 -p 4041:4041 \
  -v ${hostfolder}:${dockerfolder} \
spark3-5-1n:latest
```

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
