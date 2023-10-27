FROM elixir:latest

ADD . /app
# Install debian packages
RUN apt-get update && \
    apt-get install --yes build-essential inotify-tools postgresql-client git && \
    apt-get clean

WORKDIR /app
COPY gotham_city_app/ /app

RUN mix local.hex --force && mix local.rebar --force && mix deps.get  && mix compile

EXPOSE 4000

CMD ["/app/entrypoint.sh"]
