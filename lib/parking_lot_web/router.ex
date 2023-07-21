defmodule ParkingLotWeb.Router do
  use ParkingLotWeb, :router

  import ParkingLotWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ParkingLotWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ParkingLotWeb do
    pipe_through :browser

    get "/", PageController, :home

    delete "/users/log_out", UserSessionController, :delete

    live_session :ensure_authenticated, on_mount: {ParkingLotWeb.UserAuth, :ensure_authenticated} do
      live "/home", HomeLive.Index, :index

      scope "/drivers", DriverLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end

      scope "/vehicles", VehicleLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end

      scope "/vehicles_drivers", VehicleDriverLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end

      scope "/parkings", ParkingLive do
        live "/", Index, :index
        live "/:id", Show, :show
      end

      scope "/cameras", CameraLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end
    end
  end

  scope "/", ParkingLotWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/log_in", UserSessionController, :request
    get "/users/log_in/callback", UserSessionController, :create
  end
end
