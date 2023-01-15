defmodule ParkingLot.Customers do
  @moduledoc """
  The Customers context.
  """

  import Ecto.Query, warn: false
  alias ParkingLot.Repo

  alias ParkingLot.Customers.{Driver, Vehicle, VehicleDriver}

  def list_drivers do
    Repo.all(Driver)
  end

  def get_driver!(id), do: Repo.get!(Driver, id)

  def create_driver(attrs \\ %{}) do
    %Driver{}
    |> Driver.changeset(attrs)
    |> Repo.insert()
  end

  def update_driver(%Driver{} = driver, attrs) do
    driver
    |> Driver.changeset(attrs)
    |> Repo.update()
  end

  def delete_driver(%Driver{} = driver) do
    Repo.delete(driver)
  end

  def change_driver(%Driver{} = driver, attrs \\ %{}) do
    Driver.changeset(driver, attrs)
  end

  def list_vehicles do
    Vehicle
    |> Repo.all()
    |> preload_vehicle()
  end

  def get_vehicle!(id) do
    Vehicle
    |> Repo.get!(id)
    |> preload_vehicle()
  end

  def create_vehicle(attrs \\ %{}) do
    %Vehicle{}
    |> Vehicle.changeset(attrs)
    |> Repo.insert()
    |> preload_vehicle()
  end

  def update_vehicle(%Vehicle{} = vehicle, attrs) do
    vehicle
    |> Vehicle.changeset(attrs)
    |> Repo.update()
  end

  def delete_vehicle(%Vehicle{} = vehicle) do
    Repo.delete(vehicle)
  end

  def change_vehicle(%Vehicle{} = vehicle, attrs \\ %{}) do
    Vehicle.changeset(vehicle, attrs)
  end

  def preload_vehicle({:ok, vehicle}) do
    {:ok, preload_vehicle(vehicle)}
  end

  def preload_vehicle({:error, changeset}) do
    {:error, changeset}
  end

  def preload_vehicle(vehicle) do
    Repo.preload(vehicle, [:type, :color, model: :brand])
  end

  def list_vehicles_drivers do
    VehicleDriver
    |> Repo.all()
    |> preload_vehicle_driver()
  end

  def get_vehicle_driver!(id) do
    VehicleDriver
    |> Repo.get!(id)
    |> preload_vehicle_driver()
  end

  def create_vehicle_driver(attrs \\ %{}) do
    %VehicleDriver{}
    |> VehicleDriver.changeset(attrs)
    |> Repo.insert()
    |> preload_vehicle_driver()
  end

  def update_vehicle_driver(%VehicleDriver{} = vehicle_driver, attrs) do
    vehicle_driver
    |> VehicleDriver.changeset(attrs)
    |> Repo.update()
  end

  def delete_vehicle_driver(%VehicleDriver{} = vehicle_driver) do
    Repo.delete(vehicle_driver)
  end

  def change_vehicle_driver(%VehicleDriver{} = vehicle_driver, attrs \\ %{}) do
    VehicleDriver.changeset(vehicle_driver, attrs)
  end

  def preload_vehicle_driver({:ok, vehicle_driver}) do
    {:ok, preload_vehicle_driver(vehicle_driver)}
  end

  def preload_vehicle_driver({:error, changeset}) do
    {:error, changeset}
  end

  def preload_vehicle_driver(vehicle_driver) do
    Repo.preload(vehicle_driver, [:driver, :vehicle])
  end
end
