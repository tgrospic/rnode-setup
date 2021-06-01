#!/usr/bin/env sh

CWD=$(realpath $(dirname $BASH_SOURCE))

# Install dependencies (Docker, Docker Compose, ...)
install_dependencies () {
  apt-get update
  # Utils
  apt-get install -y htop atop mc openjdk-11-jdk-headless
  # Random generator (rnode crypto)
  apt-get install -y haveged
  update-rc.d haveged defaults
  # Docker dependencies
  apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
  # Add Docker repo key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  # Add Docker repo
  add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
  # Install Docker
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io
  # Install Docker Compose
  curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
}

# Creates initial .env file
_create_dot_env () {
  envPath="$1"
  host_ip=`ip addr show eth0 | grep -Po 'inet [0-9.]+' | awk '{print $2}'`
  if [ ! $host_ip ]; then
    host_ip="127.0.0.1"
  fi
  tee $envPath <<EOF
# RNode configuration
# ---------------------------------------------------------------------------------------------------

# External IP address, used in rnode://.... address
HOST_IP=$host_ip

# RNODE_IMAGE=rchain/rnode:v0.10.2

# gRPC protocol server SSL disabled
RNODE_IMAGE=tgrospic/rnode:grpc-ssl-off

# Main net
# RNODE_NETWORK=mainnet
# RNODE_SHARD=root

# Test net
RNODE_NETWORK=testnet02032020
RNODE_SHARD=rchain

# Uncomment in compose file if running multiple containers
MEMORY_LIMIT=16g

JMX_PORT=9991

# Devnet 2 - observer 1 https://observer1-lfs.devmainnet.dev.rchain.coop/status
# BOOTSTRAP="rnode://d74dacb93bcd0536f735711961c31ea7783fd7f3@observer1-lfs.devmainnet.dev.rchain.coop?protocol=40400&discovery=40404"

# Test net LFS observer
BOOTSTRAP="rnode://ef5438d8042be159cb84caf5ad50f8192540dff1@observer-lfs.testnet.rchain.coop?protocol=46400&discovery=46404"
EOF
}

if [ ! -f $CWD/.env ]; then
  # Create initial .env from template
  _create_dot_env $CWD/.env

  # Append to .bashrc
  tee -a ~/.bashrc <<EOF

# Custom prompt
export PS1="\[\e]0;\u@\h \w\a\]\${debian_chroot:+(\$debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w \\$\[\033[00m\] "
EOF
fi
