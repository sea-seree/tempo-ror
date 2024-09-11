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
    BUNDLE_WITHOUT="development test" \
    # ลดจำนวน log และการสร้าง document ที่ไม่จำเป็นใน bundle
    BUNDLE_CLEAN="1" \
    BUNDLE_SILENCE_ROOT_WARNING="1" \
    BUNDLE_DISABLE_SHARED_GEMS="1"

# Build stage
FROM base as build

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libvips-dev \
    pkg-config && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy gemfiles and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=3 --without development test --clean && \
    rm -rf /usr/local/bundle/cache ~/.bundle/cache /tmp/* /var/tmp/*

# Copy application code
COPY . .

# Precompile bootsnap code and assets
RUN bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile && \
    # ลบไฟล์ที่ถูกสร้างขึ้นระหว่างการ build ที่ไม่จำเป็น
    rm -rf tmp/cache app/assets vendor/assets node_modules /usr/local/bundle/cache

# Final stage for the app image
FROM base

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
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
