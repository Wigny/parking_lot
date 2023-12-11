# Parking Lot

A server-side web application designed for managing parking lot' authorized drivers and vehicles along with the automated parking registrations powered by ALPR.

## Running locally
Using Visual Studio Code, first, make sure the [`Dev Containers`](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension is installed.

Then open the project inside the Dev Container by typing <kbd>Ctrl/Cmd</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> and selecting `Dev Containers: Reopen in Container`.

It should automatically set up the environment and install the dependencies. If not, just run `mix setup` inside the terminal.

Finally, run the server with `mix phx.server` and open the browser at http://localhost:4000.

## Setting up on a server
First, make sure you have Docker properly setup on the server. Then we can start a database container with the following command:

```bash
docker run -d \
  --name parking-lot-database \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=parking_lot \
  -p 5432:5432 \
  -v postgres:/var/lib/postgresql/data \
  --restart unless-stopped \
  postgres:latest
```
> Check the [official documentation](https://hub.docker.com/_/postgres) for more information about the `postgres` image.

Now we should define the environment variables required for the application to work. We can do that by creating a `.env` file with the following content:

```sh
DATABASE_URL=ecto://postgres:postgres@172.17.0.1:5432/parking_lot
SECRET_KEY_BASE=my_ramdom_secure_and_at_least_64_bits_long_secret_______________
PHX_HOST=127.0.0.1
CACHE_DIR=/data
```

Then we should pull the latest application image running:

```bash
docker pull ghcr.io/wigny/parking_lot:latest
```

Now let's run the migrations on the database:

```bash
docker run --env-file path/to/env/file.env -it ghcr.io/wigny/parking_lot bin/migrate
```

Finally, we can start the application container:

```bash
docker run -itd \
  --name parking-lot \
  -p 4000:4000 \
  -v /tmp:/data \
  --env-file path/to/env/file.env \
  --restart unless-stopped \
  ghcr.io/wigny/parking_lot
```

We can now setup the users of the application by connecting to the remote console:

```bash
$ docker container exec -it parking-lot bin/parking_lot remote
iex> ParkingLot.Accounts.create_user(%{email: "admin@example.com", password: "password", admin: true})
iex> ParkingLot.Accounts.create_user(%{email: "viewer@example.com", password: "password", admin: false})
```

The application should start serving on port `4000` of the configured `PHX_HOST`.
