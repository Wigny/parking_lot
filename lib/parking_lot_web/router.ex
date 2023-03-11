defmodule ParkingLotWeb.Router do
  use ParkingLotWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ParkingLotWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ParkingLotWeb do
    pipe_through :browser

    get "/", PageController, :home

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
      live "/:id/show/edit", Show, :edit
    end
  end
end
