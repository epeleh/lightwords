FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y && apt-get install -y \
libssl-dev \
wget \
curl \
git \
libreadline-dev \
build-essential \
autoconf \
automake \
libtool \
make \
gcc \
g++ \
libpq-dev \
zlib1g-dev \
tzdata

WORKDIR /data
COPY . .

RUN git clone git://github.com/rbenv/rbenv.git /usr/local/rbenv
RUN git clone git://github.com/rbenv/ruby-build.git /usr/local/rbenv/plugins/ruby-build
RUN /usr/local/rbenv/plugins/ruby-build/install.sh
ENV PATH /usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv

RUN eval "$(rbenv init -)" \
&& rbenv install \
&& gem install bundler \
&& bundle config --global frozen 1 \
&& bundle config --delete bin \
&& bundle install

ENV RAILS_ENV production
ARG RAILS_MASTER_KEY
EXPOSE 3000

CMD eval "$(rbenv init -)" \
&& bundle exec rails db:setup \
;  bundle exec rails db:migrate \
&& bundle exec rails server
