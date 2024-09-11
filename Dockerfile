# syntax = docker/dockerfile:1

# Base image
ARG RUBY_VERSION=3.3.1
FROM ruby:$RUBY_VERSION-slim as base

# Set working directory
WORKDIR /rails

# Set environment variables
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# Build stage
FROM base as build

# Install build dependencies in one RUN to reduce layers (no Node.js)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libvips-dev \
    pkg-config && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy gemfiles and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=3 && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy application code
COPY . .

# Precompile bootsnap code and assets using Sprockets
RUN bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for the app image
FROM base

# Install runtime dependencies in one RUN to reduce layers
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libsqlite3-0 \
    libvips && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/*

# Copy built artifacts: gems and application code
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Add a non-root user for security
RUN useradd -ms /bin/bash rails && \
    chown -R rails:rails /rails

# Use the non-root user
USER rails

# Set entrypoint
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose the app port
EXPOSE 3000

# Start the Rails server by default
CMD ["./bin/rails", "server"]
