FROM elixir:latest

ADD .. /app
# Install debian packages
RUN apt-get update && \
    apt-get install --yes build-essential inotify-tools postgresql-client git && \
    apt-get clean

WORKDIR /app
COPY ./ /app

RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV=prod
ENV DATABASE_URL=ecto://postgres:postgres@localhost/gotham_city_dev
ENV SECRET_KEY_BASE=VtiT51ptWV9I/PSO84ikqOgfT4SXJ2oNdl4s6JJCzJWtkgsgfDyKI5lSQMHvPJx1

RUN mix deps.get && mix compile && mix phx.digest

EXPOSE 4000

CMD ["/app/entrypoint.sh"]
