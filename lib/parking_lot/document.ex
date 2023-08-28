defmodule ParkingLot.Document do
  alias ParkingLot.Digits

  @typep digits :: Digits.t()
  @typep document :: %{base: digits, check_digits: digits}

  @callback new(digits) :: document
  @callback valid?(document) :: boolean
  @callback to_digits(document) :: digits
end
