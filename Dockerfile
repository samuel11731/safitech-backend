FROM  hexpm/elixir:1.17.3-erlang-27.3.2-debian-bookworm-20250317


RUN apt-get update && apt-get install -y postgresql-client

WORKDIR /app

COPY mix.exs mix.lock ./
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only prod

COPY . .

RUN mix compile

RUN mix assets.deploy

RUN mix release

CMD ["_build/prod/rel/safitech_backend/bin/safitech_backend", "start"]
