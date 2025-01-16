ARG RUBY_VERSION=3.3.6
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base
LABEL maintainer "Michel Szinavel <michel.szinavel@gmail.com>"

ARG REFRESHED_AT
ENV REFRESHED_AT $REFRESHED_AT

# hadolint ignore=DL3009
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
  curl \
  gnupg2

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential git libpq-dev node-gyp pkg-config python-is-python3 && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install JavaScript dependencies
ARG NODE_VERSION=22.12.0
ARG YARN_VERSION=1.22.19
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
  /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
  npm install -g yarn@$YARN_VERSION && \
  rm -rf /tmp/node-build-master

RUN apt-get update
RUN apt-get install -y imagemagick libvips --fix-missing

# Point Bundler at /gems. This will cause Bundler to re-use gems that have already been installed on the gems volume
ENV BUNDLE_PATH /gems
ENV BUNDLE_HOME /gems

# Increase how many threads Bundler uses when installing. Optional!
ENV BUNDLE_JOBS 4

# How many times Bundler will retry a gem download. Optional!
ENV BUNDLE_RETRY 3

# Where Rubygems will look for gems, similar to BUNDLE_ equivalents.
ENV GEM_HOME /gems
ENV GEM_PATH /gems

ENV NODE_PATH /app/node_modules

# Add /gems/bin to the path so any installed gem binaries are runnable from bash.
ENV PATH /gems/bin:$PATH
# Add /app/node_modules to the path so any installed package binaries are runnable from bash.
ENV PATH /app/node_modules/.bin:$PATH

# Rails app lives here
ENV RAILS_ROOT /app/web_app
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

ENV RAILS_ENV=development
ENV RACK_ENV=development

COPY Gemfile ./
COPY package.json ./

RUN bundle install --jobs 5 --retry 5
RUN yarn install --check-files
COPY . $RAILS_ROOT
RUN yarn build:css

# Add a script to be executed every time the container starts.
COPY docker/app/development/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3004

CMD ["bash"]
