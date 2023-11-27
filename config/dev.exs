import Config

config :parking_lot, ParkingLot.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "parking_lot_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :parking_lot, ParkingLotWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "jVItoF805EN9xxoN60jjyWeEq4Aff7cVTT9RNyYCFC0VeuXxWu5kGVDgVGCKX2aF",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ],
  server: true

config :parking_lot, ParkingLotWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/parking_lot_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :parking_lot, dev_routes: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view, :debug_heex_annotations, true
