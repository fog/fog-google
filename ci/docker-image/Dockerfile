FROM ubuntu:16.04

# Packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -qq update && apt-get -y -qq install \
  build-essential \
  curl \
  git \
  zlib1g-dev \
  libssl-dev \
  libreadline-dev \
  libyaml-dev \
  libxml2-dev \
  libxslt-dev

# Ubuntu 16.04 will fetch us 2.3.x without any issues.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -qq install ruby ruby-dev && apt-get clean

RUN gem install bundler
