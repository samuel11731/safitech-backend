# ----------------------------
# 1. Builder Stage
# ----------------------------
FROM hexpm/elixir:1.17.3-erlang-27.3.2-debian-bookworm-20250317 AS build

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    nodejs npm \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Set environment
ENV MIX_ENV=prod

# Install hex + rebar
RUN mix local.hex --force && mix local.rebar --force

# Copy dependency files first (better caching)
COPY mix.exs mix.lock ./
COPY config config

# Fetch and compile deps
RUN mix deps.get --only prod && mix deps.compile

# Copy the rest of the app
COPY . .

# Build assets (JS/CSS) with npm + mix
RUN cd assets && npm install && npm run deploy
RUN mix assets.deploy

# Compile app + build release
RUN mix compile
RUN mix release

# ----------------------------
# 2. Runtime Stage
# ----------------------------
FROM debian:bookworm-slim AS runtime

RUN apt-get update && apt-get install -y \
    postgresql-client \
    openssl \
    libncurses5 \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy release from build stage
COPY --from=build /app/_build/prod/rel/safitech_backend ./safitech_backend

# Expose port (default Phoenix port)
EXPOSE 4000

# Run the release
CMD ["./safitech_backend/bin/safitech_backend", "start"]
