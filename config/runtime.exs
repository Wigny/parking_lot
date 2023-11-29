import Config

config :parking_lot,
  cache_dir: System.get_env("CACHE_DIR") || :filename.basedir(:user_cache, "")

if System.get_env("PHX_SERVER") do
  config :parking_lot, ParkingLotWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :parking_lot, ParkingLot.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  # secret_key_base =
  #   System.get_env("SECRET_KEY_BASE") ||
  #     raise """
  #     environment variable SECRET_KEY_BASE is missing.
  #     You can generate one by calling: mix phx.gen.secret
  #     """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :parking_lot, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :parking_lot, ParkingLotWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}, port: port]

  # , secret_key_base: secret_key_base
end
