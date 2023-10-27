defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug(CORSPlug,
      origin: "*",
      methods: ["GET", "POST", "PUT", "DELETE"],
      allow_headers: ["acccess-control-allow-origin", "authorization", "content-type"])
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api
    scope "/users" do
      get "/", UserController, :index
      get "/:userID", UserController, :show
      post "/", UserController, :create
      put "/:userID", UserController, :update
      delete "/:userID", UserController, :delete
    end
    scope "/clocks" do
      get "/:userID", ClockController, :show
      post "/:userID", ClockController, :update
    end
    scope "/workingtimes" do
      get "/:userID", WorkingtimeController, :index
      get "/:userID/:id", WorkingtimeController, :show
      post "/:userID", WorkingtimeController, :create
      put "/:id", WorkingtimeController, :update
      delete "/:id", WorkingtimeController, :delete
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
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
