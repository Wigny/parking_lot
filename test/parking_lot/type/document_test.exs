defmodule ParkingLot.Type.DocumentTest do
  use ExUnit.Case, async: true

  import ParkingLot.Digits

  defmodule ID do
    @behaviour ParkingLot.Document

    defstruct [:digits]

    def new(digits) do
      if length(digits) === 3 do
        {:ok, %__MODULE__{digits: digits}}
      else
        {:error, %{reason: "invalid length"}}
      end
    end

    def to_digits(id), do: id.digits
    def to_string(id), do: "ID<#{id.digits}>"
  end

  describe "document" do
    setup do
      %{type: {:parameterized, ParkingLot.Type.Document, %{type: ID}}}
    end

    test "cast", %{type: type} do
      assert Ecto.Type.cast(type, "123") == {:ok, %ID{digits: ~d[123]}}
      assert Ecto.Type.cast(type, ~d[123]) == {:ok, %ID{digits: ~d[123]}}
      assert Ecto.Type.cast(type, %ID{digits: ~d[123]}) == {:ok, %ID{digits: ~d[123]}}
      assert Ecto.Type.cast(type, nil) == {:ok, nil}
      assert Ecto.Type.cast(type, ~d[1234]) == {:error, message: "invalid length"}
      assert Ecto.Type.cast(type, :invalid) == :error
    end

    test "load", %{type: type} do
      assert Ecto.Type.load(type, "123") == {:ok, %ID{digits: ~d[123]}}
      assert Ecto.Type.load(type, nil) == {:ok, nil}
    end

    test "dump", %{type: type} do
      assert Ecto.Type.dump(type, %ID{digits: ~d[123]}) == {:ok, "123"}
      assert Ecto.Type.dump(type, nil) == {:ok, nil}
      assert Ecto.Type.dump(type, :invalid) == :error
    end
  end
end
