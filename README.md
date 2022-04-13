## Running RChain node from Last Finalized State

This repo contains scripts, configurations and instructions for quick start of RChain node (RNode). Also it has the purpose to demonstrate **Last Finalized State** feature which enables node to sync with the network from _last finalized block_.

NOTE: Currently, setup is provided only for node running inside Docker container and tested on Ubuntu (20.04).

## Install

[install.sh](install.sh) script contains commands to install all necessary dependencies. It will also generate **.env** file with the default variables used by Docker Compose for easier modification.  
Script will try to find external IP address from network adapter and set `HOST_IP` variable in `.env` file. If network adapter `eth0` is not found, `HOST_IP` must be set manually.

```sh
curl https://raw.githubusercontent.com/tgrospic/rnode-setup/master/install.sh | bash
```

## Hardware requirenments

JVM memory limit can be specified in two ways.

Percentage of the total memory (or container limit) e.g. `-XX:MaxRAMPercentage=50`.  
Absolute value e.g. `-Xmx2g`, `-Xmx2500m`.

The memory limit determines maximum memory for Java heap used by the node. On top of that **enough memory must be left for disk cache used by the OS and JVM**. At least 2GB of memory should be left free. If this value is too low, Linux kernel will *kill* the process and Docker container will exit with code 137.

This table shows possible memory settings depending on the total memory size.

| Total \ Java opt. | Relative<br>`-XX:MaxRAMPercentage` | Absolute<br>`-Xmx` |
|:-----------------:|:----------------------------------:|:------------------:|
| 3GB               |                                 30 |                 1g |
| 4GB               |                                 50 |                 2g |
| **8GB**           |                                 65 |                 5g |
| **16GB**          |                                 75 |                12g |

**Recommended memory for validators is 16GB on main net and 8GB on test net.**

## Run

After all dependencies installed, RNode can be started with Docker Compose. Command must be executed in the same directory with [docker-compose.yml](docker-compose.yml) which contains RNode configuration.  
Part of the configuration will be generated with _install.sh_ script to **.env** file which is read by Docker Compose.

```sh
docker-compose up -d
```

## Install on cloud

In the [cloud](cloud) directory are initialization scripts which can be used when creating VPS machines on [Hetzner](https://community.hetzner.com/tutorials/basic-cloud-config) and [DigitalOcean](https://www.digitalocean.com/blog/automating-application-deployments-with-user-data/) cloud providers.

```yml
#cloud-config

# https://cloudinit.readthedocs.io/en/latest/topics/examples.html

# run commands
# https://cloudinit.readthedocs.io/en/latest/topics/examples.html#run-commands-on-first-boot
runcmd:
  - "curl https://raw.githubusercontent.com/tgrospic/rnode-setup/master/install.sh | bash"
```

## JVM diagnostics

Docker Compose configuration contains Java options to enable JMX connection to JVM process. [VisualVM](https://visualvm.github.io/) GUI tool can be used to connect and monitor JVM parameters like CPU and memory usage, perform GC, etc.  
NOTE: To monitor Direct Buffer memory install _VisualVM-BufferMonitor_ plugin which can be found under _Tools > Plugins > Available Plugins_ menu.

With SSH tunneling, JMX port can be made accessible to local machine where VisualVM is running at `localhost:9991`.

```sh
ssh <node-ip> -L 9991:localhost:9991
```

![image](https://user-images.githubusercontent.com/5306205/158129420-8825f639-5207-4f5e-a256-136cae6edc93.png)
