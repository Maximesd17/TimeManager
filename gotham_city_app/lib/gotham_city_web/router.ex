defmodule GothamCityWeb.Router do
  use GothamCityWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {GothamCityWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :jwt do
    plug GothamCityWeb.JwtAuthPlug
  end

  scope "/api", GothamCityWeb do
    pipe_through(:api)

    #secured users route
    scope "/users" do
      pipe_through(:jwt)
      get("/", UserController, :identifier)
      get("/:userID", UserController, :show)
      put("/:userID", UserController, :update)
      delete("/:userID", UserController, :delete)
    end

    scope "/users" do
      post("/", UserController, :create)
      #post("/", UserController, :login)
    end

    scope "/workingtimes" do
      get("/:userID", WorkingtimeController, :index)
      get("/:userID/:id", WorkingtimeController, :show)
      post("/:userID", WorkingtimeController, :create)
      put("/:id", WorkingtimeController, :update)
      delete("/:id", WorkingtimeController, :delete)
    end

    scope "/clocks" do
      get("/:userID", ClockController, :show)
      post("/:userID", ClockController, :update)
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:gotham_city, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: GothamCityWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
