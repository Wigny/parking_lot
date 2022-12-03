defmodule ParkingLotWeb.Router do
  use ParkingLotWeb, :router

  import ParkingLotWeb.UserAuth,
    only: [
      fetch_current_user: 2,
      require_authenticated_user: 2,
      redirect_if_user_is_authenticated: 2
    ]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ParkingLotWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ParkingLotWeb do
    pipe_through :browser

    delete "/users/log_out", UserSessionController, :delete
  end

  scope "/", ParkingLotWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/", PageLive.Index, :index

    live "/drivers", DriverLive.Index, :index
    live "/drivers/new", DriverLive.Index, :new
    live "/drivers/:id", DriverLive.Show, :show

    live "/vehicles", VehicleLive.Index, :index
    live "/vehicles/new", VehicleLive.Index, :new
    live "/vehicles/:id", VehicleLive.Show, :show
  end

  scope "/", ParkingLotWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/log_in", UserSessionController, :new

    get "/auth/:provider", UserOAuthController, :request
    get "/auth/:provider/callback", UserOAuthController, :callback
  end
end
