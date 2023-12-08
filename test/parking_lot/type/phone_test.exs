defmodule ParkingLot.Type.PhoneTest do
  use ExUnit.Case, async: true

  alias ParkingLot.Type.Phone, as: Type

  @phone %ParkingLot.Phone{number: 99_998_765_432, code: 55}

  describe "phone" do
    test "cast" do
      assert Ecto.Type.cast(
               {:parameterized, Type, %{country: "BR"}},
               "(99) 99876-5432"
             ) == {:ok, @phone}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{country: nil}},
               "+55 (99) 99876-5432"
             ) == {:ok, @phone}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{country: nil}},
               "(99) 99876-5432"
             ) == {:error, [message: "invalid country code"]}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{country: "BR"}},
               "1"
             ) == {:error, [message: "not a number"]}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{}},
               @phone
             ) == {:ok, @phone}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{}},
               nil
             ) == {:ok, nil}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{}},
               :invalid
             ) == :error
    end

    test "load" do
      <<?+, number::binary>> = ParkingLot.Phone.to_number(@phone)

      assert Ecto.Type.load({:parameterized, Type, %{}}, number) == {:ok, @phone}
      assert Ecto.Type.load({:parameterized, Type, %{}}, nil) == {:ok, nil}
    end

    test "dump" do
      <<?+, number::binary>> = ParkingLot.Phone.to_number(@phone)

      assert Ecto.Type.dump({:parameterized, Type, %{}}, @phone) == {:ok, number}
      assert Ecto.Type.dump({:parameterized, Type, %{}}, nil) == {:ok, nil}
      assert Ecto.Type.dump({:parameterized, Type, %{}}, :invalid) == :error
    end
  end
end
