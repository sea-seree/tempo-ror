# syntax = docker/dockerfile:1

# Use Alpine-based Ruby image for a smaller base image
ARG RUBY_VERSION=3.3.1
FROM ruby:$RUBY_VERSION-alpine as base
# FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_WITHOUT="development test" \
    BUNDLE_PATH="/usr/local/bundle"

# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems
RUN apk update && apk add --no-cache \
    build-base \
    git \
    libvips \
    pkgconfig \
    sqlite-dev


# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set clean 'true' && \
    bundle install && \
    rm -rf ~/.bundle/vendor/bundle/ruby/*/cache

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets for production
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apk add --no-cache \
    curl \
    libvips \
    sqlite-libs

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Use non-root user for security
RUN adduser -D -g '' rails && \
    chown -R rails:rails /rails
USER rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
