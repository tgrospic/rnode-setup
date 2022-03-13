# Running RChain node from Last Finalized State

This repo contains scripts, configurations and instructions for quick start of RChain node (RNode). Also it has the purpose to demonstrate **Last Finalized State** feature which enables node to sync with the network from _last finalized block_.

NOTE: Currently, setup is provided only for node running inside Docker container and tested on Ubuntu (20.04).

# Install

[install.sh](install.sh) script contains commands to install all necessary dependencies. It will also generate **.env** file with the default variables used by Docker Compose for easier modification.  
Script will try to find external IP address from network adapter and set `HOST_IP` variable in `.env` file. If network adapter `eth0` is not found, `HOST_IP` must be set manually.

```sh
curl https://raw.githubusercontent.com/tgrospic/rnode-setup/master/install.sh | bash
```

## Run

After all dependencies installed, RNode can be started with Docker Compose. Command must be executed in the same directory with [docker-compose.yml](docker-compose.yml) which contains RNode configuration.  
Part of the configuration will be generated with _install.sh_ script to **.env** file which is read by Docker Compose.

```sh
docker-compose up -d
```

# Install on cloud

In the [cloud](cloud) directory are initialization scripts which can be used when creating VPS machines on [Hetzner](https://community.hetzner.com/tutorials/basic-cloud-config) and [DigitalOcean](https://www.digitalocean.com/blog/automating-application-deployments-with-user-data/) cloud providers.

```yml
#cloud-config

# https://cloudinit.readthedocs.io/en/latest/topics/examples.html

# run commands
# https://cloudinit.readthedocs.io/en/latest/topics/examples.html#run-commands-on-first-boot
runcmd:
  - "curl https://raw.githubusercontent.com/tgrospic/rnode-setup/master/install.sh | bash"
```
