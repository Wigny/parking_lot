import Config

config :ueberauth, Ueberauth,
  providers: [
    google: {
      Ueberauth.Strategy.Google,
      [
        request_path: "/users/log_in",
        callback_path: "/users/log_in/callback"
      ]
    }
  ]

config :parking_lot,
  ecto_repos: [ParkingLot.Repo]

config :parking_lot, ParkingLotWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: ParkingLotWeb.ErrorHTML, json: ParkingLotWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ParkingLot.PubSub,
  live_view: [signing_salt: "AWf5tVrn"]

config :esbuild,
  version: "0.17.11",
  default: [
    args: ~w(
      js/app.js
        --bundle
        --target=es2017
        --outdir=../priv/static/assets
        --external:/fonts/*
        --external:/images/*
    ),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
