## What is base image eclipse-temurin:17-jre-jammy? What is it based on?



## Error while running docker build `docker build -t spark3-5-1n .`

```bash
[+] Building 1.2s (2/2) FINISHED                                       docker:default
 => [internal] load build definition from Dockerfile                             0.0s
 => => transferring dockerfile: 2.28kB                                           0.0s
 => ERROR [internal] load metadata for docker.io/library/eclipse-temurin:17-jre  1.1s
------
 > [internal] load metadata for docker.io/library/eclipse-temurin:17-jre-jammy:
------
Dockerfile:1
--------------------
   1 | >>> FROM eclipse-temurin:17-jre-jammy
   2 |     
   3 |     ARG spark_uid=185
--------------------
ERROR: failed to solve: eclipse-temurin:17-jre-jammy: failed to resolve source metadata for docker.io/library/eclipse-temurin:17-jre-jammy: error getting credentials - err: exec: "docker-credential-desktop": executable file not found in $PATH, out: ``
```

Solution: https://stackoverflow.com/questions/65896681/exec-docker-credential-desktop-exe-executable-file-not-found-in-path


## Error while running docker run command

Error: docker: Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: exec: "/opt/entrypoint.sh": permission denied: unknown.`docker run --rm -it   -p 4040:4040 -p 4041:4041   -v ${hostfolder}:${dockerfolder} spark3-5-1n:latest`

Solution:


## What is base image eclipse-temurin:17-jre-jammy? What is it based on?
