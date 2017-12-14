## Docker for development
Eclipse che is a cloud based IDE which runs the development environment in docker. The interface is RIA running on a browser.

1. Create a folder called data
2. Set an environment variable ECLIPSE_CHE pointing to the above folder
```sh
    export CHE_DATA=<absolute path to the data foder>
```
3. Run the following commands

CLI:

```sh
docker run -v $CHE_DATA/data:/data -v /var/run/docker.sock:/var/run/docker.sock eclipse/che start
```

Compose:
```sh
 docker-compose -f docker-compose-che.yml up
 ```

## Artifactory with Docker
CLI:
```sh
docker run --name artifactory -d -p 8081:8081 docker.bintray.io/jfrog/artifactory-pro:latest
```
Compose:
```sh
docker-compose -d -f docker-compose-artifactory.yml up
```

# Initialise Docker Swarm
## Setting up swarm

```
docker swarm init --advertise-addr <machine's IP address>
```

## Adding a manager to the swarm
```sh
# Get the token for a manager from an existing swarm master
docker swarm join-token manager

docker swarm join \
    --token <token value> \
    <Manager IP>:<Manager Port>
```

## Adding a worker to the swarm
```sh
# Get the token for a worker from an existing swarm master
docker swarm join-token worker

docker swarm join \
    --token <token value> \
    <Manager IP>:<Manager Port>
```
## Adding db-node label
```sh
 db-node docker node update --label-add type=db-node <node id>
```
## Using db-node label for database containers

```yaml
version: '3.4'

services:
  db:
    image: mysql
    volumes:
      - mysql-test:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=password
    deploy:
      replicas: 1
      placement:
        constraints:
          - node.labels.type == db-node
volumes:
  mysql-test:

```
```
docker stack deploy -c docker-compose-mysql-test.yml mysql-test
```

### Adding docker swarm visualiser

```
docker stack deploy -c docker-compose-viz.yml viz
```

## Cleaning up Docker nodes by removing old images and inactive containers

Use Spoify's awesome [gc tool] (https://github.com/spotify/docker-gc) in a container to clean up docker nodes