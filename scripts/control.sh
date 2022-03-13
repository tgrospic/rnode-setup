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

# Creates initial .env file from template
_create_dot_env () {
  envPath="$1"
  host_ip=`ip addr show eth0 | grep -Po 'inet [0-9.]+' | awk '{print $2}'`
  if [ ! $host_ip ]; then
    host_ip="127.0.0.1"
  fi
  # Create .env from template file
  envsubst < $CWD/template.env > $envPath

  echo ".env config file created"
}

envPath="$CWD/../.env"

if [ ! -f $envPath ]; then
  # Create initial .env file
  _create_dot_env $envPath

  # Append to .bashrc
  tee -a ~/.bashrc <<EOF

# Custom prompt
export PS1="\[\e]0;\u@\h \w\a\]\${debian_chroot:+(\$debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w \\$\[\033[00m\] "
EOF
fi
