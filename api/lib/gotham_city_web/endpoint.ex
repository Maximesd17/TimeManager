defmodule TimeManagerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :gotham_city

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_gotham_city_key",
    signing_salt: "nR20mFji",
    same_site: "Lax"
  ]

  socket("/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]])

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug(Plug.Static,
    at: "/",
    from: :gotham_city,
    gzip: false,
<<<<<<<< HEAD:api/lib/gotham_city_web/endpoint.ex
    only: TimeManagerWeb.static_paths()
========
    only: GothamCityWeb.static_paths()
  )
>>>>>>>> origin/val:gotham_city_app/lib/gotham_city_web/endpoint.ex

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
<<<<<<<< HEAD:api/lib/gotham_city_web/endpoint.ex
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :gotham_city
========
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
    plug(Phoenix.Ecto.CheckRepoStatus, otp_app: :gotham_city)
>>>>>>>> origin/val:gotham_city_app/lib/gotham_city_web/endpoint.ex
  end

  plug(Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"
  )

  plug(Plug.RequestId)
  plug(Plug.Telemetry, event_prefix: [:phoenix, :endpoint])

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

<<<<<<<< HEAD:api/lib/gotham_city_web/endpoint.ex
  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug TimeManagerWeb.Router
========
  plug(Plug.MethodOverride)
  plug(Plug.Head)
  plug(Plug.Session, @session_options)

  plug(CORSPlug)
  plug(GothamCityWeb.Router)
>>>>>>>> origin/val:gotham_city_app/lib/gotham_city_web/endpoint.ex
end
