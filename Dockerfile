FROM ubuntu:14.04
MAINTAINER Alejandro Gomez <amoron@emergya.com>

#================================
# Build arguments
#================================

#================================
# Env variables
#================================

ENV DEBIAN_FRONTEND noninteractive

#================================
# Instance build
#================================

# Adding the resources
ADD assets/etc/apt/apt.conf.d/99norecommends /etc/apt/apt.conf.d/99norecommends
ADD assets/etc/apt/sources.list /etc/apt/sources.list

# Installing the stack (python-software-properties is for runing the apt-add-repository)
RUN apt-get update -y \
  && apt-get install -y -q build-essential wget git python-software-properties software-properties-common nodejs npm

# Ruby stack needed for scss-lint
RUN apt-add-repository ppa:brightbox/ruby-ng \
  && apt-get update -y \
  && apt-get install -y ruby2.2 ruby2.2-dev

# Install npm stack
RUN npm install -y -g bower \
  && npm install -y -g gulp \
  && npm link gulp \
  && ln -s /usr/bin/nodejs /usr/bin/node \
  && apt-get -qqy clean && rm -rf /var/cache/apt/*

# Install scss_lint
RUN gem install sass scss-lint

WORKDIR /src

EXPOSE 8080

# Adding the entrypoint
COPY ./assets/bin/entrypoint /
RUN chmod +x /entrypoint
ENTRYPOINT ["/entrypoint"]