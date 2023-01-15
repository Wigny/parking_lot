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

    get "/", PageController, :index

    live "/drivers", DriverLive.Index, :index
    live "/drivers/new", DriverLive.Index, :new
    live "/drivers/:id/edit", DriverLive.Index, :edit

    live "/drivers/:id", DriverLive.Show, :show
    live "/drivers/:id/show/edit", DriverLive.Show, :edit

    live "/vehicles", VehicleLive.Index, :index
    live "/vehicles/new", VehicleLive.Index, :new
    live "/vehicles/:id/edit", VehicleLive.Index, :edit

    live "/vehicles/:id", VehicleLive.Show, :show
    live "/vehicles/:id/show/edit", VehicleLive.Show, :edit

    live "/vehicles_drivers", VehicleDriverLive.Index, :index
    live "/vehicles_drivers/new", VehicleDriverLive.Index, :new
    live "/vehicles_drivers/:id/edit", VehicleDriverLive.Index, :edit

    live "/vehicles_drivers/:id", VehicleDriverLive.Show, :show
    live "/vehicles_drivers/:id/show/edit", VehicleDriverLive.Show, :edit
  end

  scope "/", ParkingLotWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/log_in", UserSessionController, :new

    get "/auth/:provider", UserOAuthController, :request
    get "/auth/:provider/callback", UserOAuthController, :callback
  end
end
