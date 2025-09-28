# syntax = docker/dockerfile:1

# ---- Base image ----
ARG RUBY_VERSION=3.1.3
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    build-essential \
    git \
    pkg-config \
    libpq-dev \
    sqlite3 libsqlite3-dev \
    libjemalloc2 \
    libvips \
    nodejs \
    yarn \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Environment variables
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# ---- Build stage ----
FROM base AS build

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

COPY . .

# Precompile app code (bootsnap, assets if any)
RUN bundle exec bootsnap precompile app/ lib/

# ---- Final stage ----
FROM base

# Copy built gems and app
COPY --from=build ${BUNDLE_PATH} ${BUNDLE_PATH}
COPY --from=build /rails /rails

# Create non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash --gid 1000 rails && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint script to run migrations before boot
ENTRYPOINT ["./bin/rails", "db:prepare", "&&"]

# Expose default Rails port
EXPOSE 3000

# Start server
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]

