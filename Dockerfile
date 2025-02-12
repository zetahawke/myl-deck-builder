# Make sure it matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.6
FROM ruby:$RUBY_VERSION

ARG NODE_VERSION=22.12.0
ARG YARN_VERSION=1.22.19
# Install libvips for Active Storage preview support
RUN apt-get update -qq && \
    apt-get install -y build-essential libvips bash bash-completion libffi-dev tzdata postgresql nodejs npm yarn --fix-missing && \
    apt-get install -y imagemagick libvips --fix-missing

ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION

# # Set production environment
# ENV RAILS_LOG_TO_STDOUT="1" \
#     RAILS_SERVE_STATIC_FILES="true" \
#     RAILS_ENV="development" \
#     BUNDLE_WITHOUT="development"

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
ENV RAILS_ROOT /app/rails
RUN mkdir -p $RAILS_ROOT
RUN mkdir -p $NODE_PATH
RUN mkdir -p $GEM_HOME
WORKDIR $RAILS_ROOT

ENV RAILS_ENV=development
ENV RACK_ENV=development

# Install application gems
COPY package.json ./
COPY Gemfile Gemfile.lock ./

RUN yarn install
RUN bundle install

# Copy application code
COPY . .
RUN yarn build:css

# Precompile bootsnap code for faster boot times
# RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
# RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Entrypoint prepares the database.
# ENTRYPOINT ["/rails/bin/docker-entrypoint"]
# Add a script to be executed every time the container starts.
COPY docker/app/development/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3004

# Start the server by default, this can be overwritten at runtime
EXPOSE 3004
# CMD ["./bin/rails", "server", "-b 0.0.0.0", "-p 3004"]
CMD ["./bin/dev"]