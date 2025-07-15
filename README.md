# README

## Prerequisites:

* A server with Docker Engine installed.
* The application source code available on the server.
* The value of the RAILS_MASTER_KEY from config/master.key.

## Deployment Steps:

### Build the Docker Image:
Navigate to the application's root directory and run the build command. This will create a Docker image named taryma_com.

```
docker build -t taryma_com .
```

### Run the Docker Container:
Execute the following command to start the application. You must replace <value from config/master.key> with your actual RAILS_MASTER_KEY.

````
docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name taryma_com taryma_com
```
* `-d`: Runs the container in detached mode.
* `-p 80:80`: Maps port 80 on the host to port 80 in the container.
* `-e RAILS_MASTER_KEY=...`: Securely provides the master key as an environment variable.
* `--name taryma_com`: Assigns a name to the container for easier management.

### Database and Application Setup:
The Dockerfile specifies an ENTRYPOINT script that likely handles database creation, migrations, and other setup tasks automatically when the container starts.