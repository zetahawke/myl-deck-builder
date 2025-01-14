# Make sure it matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.6
FROM ruby:$RUBY_VERSION

ARG NODE_VERSION=22.12.0
ARG YARN_VERSION=1.22.19
# Install libvips for Active Storage preview support
RUN apt-get update -qq && \
    apt-get install -y build-essential libvips bash bash-completion libffi-dev tzdata postgresql nodejs npm yarn && \
    apt-get install -y imagemagick libvips --fix-missing

ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION

# Rails app lives here
WORKDIR /rails

# # Set production environment
# ENV RAILS_LOG_TO_STDOUT="1" \
#     RAILS_SERVE_STATIC_FILES="true" \
#     RAILS_ENV="development" \
#     BUNDLE_WITHOUT="development"

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
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3004
CMD ["./bin/rails", "server"]