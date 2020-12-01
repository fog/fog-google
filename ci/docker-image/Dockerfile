FROM ubuntu:18.04

# Common dependencies for the CI env and gems with C extensions
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

# Ubuntu 18.04 will fetch us Ruby 2.5.x
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -qq install ruby ruby-dev && apt-get clean

RUN gem install bundler
