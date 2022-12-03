import Config

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

config :parking_lot,
  ecto_repos: [ParkingLot.Repo]

config :parking_lot, ParkingLot.Repo,
  migration_timestamps: [
    type: :utc_datetime
  ]

config :parking_lot, ParkingLotWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ParkingLotWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ParkingLot.PubSub,
  live_view: [signing_salt: "AWf5tVrn"]

config :esbuild,
  version: "0.14.29",
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

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
