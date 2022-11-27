defmodule ParkingWeb.Router do
  use ParkingWeb, :router

  import ParkingWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ParkingWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ParkingWeb do
    pipe_through :browser

    get "/", PageController, :index

    delete "/users/log_out", UserSessionController, :delete
  end

  scope "/", ParkingWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/hello_world", WorldLive.Index, :index
  end

  scope "/", ParkingWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/log_in", UserSessionController, :new

    get "/auth/:provider", UserOAuthController, :request
    get "/auth/:provider/callback", UserOAuthController, :callback
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
