defmodule ParkingLot.CustomersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ParkingLot.Customers` context.
  """

  @doc """
  Generate a unique driver cnh.
  """
  def unique_driver_cnh, do: "some cnh#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique driver cpf.
  """
  def unique_driver_cpf, do: "some cpf#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique driver email.
  """
  def unique_driver_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique driver phone.
  """
  def unique_driver_phone, do: "some phone#{System.unique_integer([:positive])}"

  @doc """
  Generate a driver.
  """
  def driver_fixture(attrs \\ %{}) do
    {:ok, driver} =
      attrs
      |> Enum.into(%{
        active: true,
        cnh: unique_driver_cnh(),
        cpf: unique_driver_cpf(),
        email: unique_driver_email(),
        name: "some name",
        phone: unique_driver_phone()
      })
      |> ParkingLot.Customers.create_driver()

    driver
  end
end
