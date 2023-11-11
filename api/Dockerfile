FROM elixir:1.14

ADD .. /app
# Install debian packages
RUN apt-get update && \
    apt-get install --yes build-essential inotify-tools postgresql-client git && \
    apt-get clean

WORKDIR /app
COPY ./ /app

RUN mix local.hex --force && mix local.rebar --force && mix deps.get && mix compile && mix phx.digest

EXPOSE 4000

CMD ["/app/entrypoint.sh"]
