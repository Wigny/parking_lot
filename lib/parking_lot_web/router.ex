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

    delete "/users/log_out", UserSessionController, :delete
  end

  scope "/", ParkingLotWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :ensure_authenticated, on_mount: {ParkingLotWeb.UserAuth, :ensure_authenticated} do
      live "/home", HomeLive.Index, :index

      scope "/parkings", ParkingLive do
        live "/", Index, :index
        live "/:id", Show, :show
      end
    end

    live_session :ensure_authorized,
      on_mount: [
        {ParkingLotWeb.UserAuth, :ensure_authenticated},
        {ParkingLotWeb.UserAuth, :ensure_authorized}
      ] do
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

      scope "/cameras", CameraLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end

      scope "/vehicle/models", VehicleModelLive do
        live "/", Index, :index
        live "/new", Index, :new
        live "/:id/edit", Index, :edit

        live "/:id", Show, :show
        live "/:id/show/edit", Show, :edit
      end

      scope "/vehicle/brands", VehicleBrandLive do
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

    get "/", PageController, :index

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{ParkingLotWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/log_in", UserLoginLive, :new
    end

    post "/users/log_in", UserSessionController, :create
  end
end
