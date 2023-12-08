defmodule ParkingLot.PhoneTest do
  use ExUnit.Case, async: true

  alias ParkingLot.Phone

  doctest Phone

  @phone %Phone{code: 55, number: 99_999_999_999}

  describe "new/2" do
    test "with a invalid country code" do
      assert {:error, %Phone.Error{reason: "invalid country code"}} =
               Phone.new("(99) 99999-9999", "invalid")
    end

    test "with a too short phone number" do
      assert {:error, %Phone.Error{reason: "too short"}} = Phone.new("999", "BR")
    end

    test "with a too long phone number" do
      assert {:error, %Phone.Error{reason: "too long"}} = Phone.new("9999 9999 9999", "BR")
    end

    test "with a invalid length phone number" do
      assert {:error, %Phone.Error{reason: "invalid length"}} = Phone.new("999999999", "US")
    end

    test "with a unmatched country code" do
      assert {:error, %Phone.Error{reason: "invalid country code"}} =
               Phone.new("+55 (99) 99999-9999", "US")
    end
  end

  describe "parse/2" do
    test "with a valid international number" do
      assert {:ok, @phone} = Phone.new("+55 (99) 99999-9999")
    end

    test "with a valid national number and country code" do
      assert {:ok, @phone} = Phone.new("(99) 99999-9999", "BR")
    end

    test "with an invalid national number" do
      assert {:error, %Phone.Error{}} = Phone.new("invalid", "BR")
    end

    test "with and invalid international number" do
      assert {:error, %Phone.Error{}} = Phone.new("+55 invalid")
    end
  end

  describe "valid?/1" do
    test "with a valid phone" do
      assert Phone.valid?(@phone)
    end

    test "with an invalid phone" do
      refute Phone.valid?(%Phone{code: 55, number: 10})
    end
  end

  describe "to_number/1" do
    test "returns a phone number" do
      assert "+5599999999999" = Phone.to_number(@phone)
    end
  end

  describe "to_string/1" do
    test "retuns a formatted phone number" do
      assert "+55 99 99999-9999" = Phone.to_string(@phone)
    end
  end

  describe "to_uri/1" do
    test "returns a tel URI" do
      assert %URI{scheme: "tel", path: "+55-99-99999-9999"} = Phone.to_uri(@phone)
    end
  end
end
