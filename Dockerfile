FROM ubuntu:14.04
MAINTAINER Alejandro Gomez <amoron@emergya.com>

#================================
# Build arguments
#================================

#================================
# Env variables
#================================

ENV DEBIAN_FRONTEND noninteractive
ENV NODE_VERSION 6.5.0

#================================
# Instance build
#================================

# Adding the resources
ADD assets/etc/apt/apt.conf.d/99norecommends /etc/apt/apt.conf.d/99norecommends
ADD assets/etc/apt/sources.list /etc/apt/sources.list

# Installing the stack (python-software-properties is for runing the apt-add-repository)
RUN apt-get update -y \
  && apt-get install -y -q wget \
  # Installing nodejs from binaries
  && cd /tmp  \
  && wget "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" -O node-linux-x64.tar.gz --no-check-certificate \
  && tar -zxvf "node-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm node-linux-x64.tar.gz \
  # binding node globally
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  # installing the rest of the stack
  && apt-get install -y -q git python-software-properties software-properties-common build-essential

# Ruby stack needed for scss-lint
RUN apt-add-repository ppa:brightbox/ruby-ng \
  && apt-get update -y \
  && apt-get install -y ruby2.2 ruby2.2-dev

# Install npm stack
RUN npm install bower -g \
  && npm install gulp -g \
  && ln -s /usr/local/bin/gulp /usr/bin/gulp \
  && apt-get -qqy clean && rm -rf /var/cache/apt/*

# Install scss_lint
RUN gem install sass scss-lint

WORKDIR /src

EXPOSE 8080

# Adding the entrypoint
COPY ./assets/bin/entrypoint /
RUN chmod +x /entrypoint
ENTRYPOINT ["/entrypoint"]