FROM elixir:1.18-alpine

RUN apk add --no-cache build-base git inotify-tools postgresql-client

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
RUN mix deps.get

COPY . .

RUN mix deps.compile

EXPOSE 4000

CMD ["./entrypoint.sh"]
