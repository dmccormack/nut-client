# Network UPS Tools client

Docker image for a Network UPS Tools client to issue a shutdown command on the host machine. This container connects to a remote UPS running a NUTs server.

## Usage

Provide the environment variables to connect to the remote UPS.

### UPS_DEVICE

*Example*: `qnapups@172.20.12.20`

The name of the UPS.

### UPS_USER

*Example*: `admin`

The user name for logging into remote UPS.

### UPS_PASSWORD

*Example*: `123456`

The user password for logging into remote UPS.


###  docker-compose.yml

```console
version: '3'

services:
  nut-client:
    image: declanmccormack/nut-client:latest
    container_name: nut-client
    restart: unless-stopped
    environment:
      - UPS_DEVICE=${UPS_DEVICE}
      - UPS_USER=${UPS_USER}
      - UPS_PASSWORD=${UPS_PASSWORD}
    volumes:
      - /tmp/nut-client:/tmp/nut-client
```

Start the container:

```console
# docker-compose up -d
```

Check that you have access to the remote UPS.

```console
# docker exec -it nut-client upsc <UPS_DEVICE>
```

## Host Shutdown

When a shutdown signal is detected the container will write a `1` into a file with the name `monitor` located in the `/tmp/nut-client` folder that was mapped earlier.

`host-shutdown-action.sh` contains a cron script to be executed on the host machine. It is recommended to run it every minute. When it reads a value of `1` in the file `/tmp/nut-client/monitor` it will execute a shutdown action.


``` console
[...]
shutdown_action(){
  # Power off in 5 minutes
  shutdown -P +5

  echo "Stop all Docker containers..."
  docker stop $(docker ps -a -q) -t 300
}
[...]
```

