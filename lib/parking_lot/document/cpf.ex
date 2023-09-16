defmodule ParkingLot.Document.CPF do
  @moduledoc """
  CPF (Cadastro de Pessoa Física) document implementation.

  Validation based on the [validation-br](https://github.com/klawdyo/validation-br/blob/v.1.4.2/src/cpf.ts) JS library.
  """
  alias ParkingLot.{Digits, Document}

  @behaviour Document

  defstruct [:base, :check_digits]

  defmodule Error do
    defexception [:reason]

    def new(fields), do: struct!(__MODULE__, fields)

    def message(%{reason: "invalid digits"}), do: "The CPF is invalid"
  end

  @impl true
  def new(digits) do
    {base, check_digits} = Enum.split(Digits.pad_leading(digits, 11), -2)

    if not Digits.monodigit?(base) and match?(^check_digits, check_digits(base)) do
      {:ok, struct(__MODULE__, base: base, check_digits: check_digits)}
    else
      {:error, Error.new(reason: "invalid digits")}
    end
  end

  @impl true
  def to_digits(%{base: base, check_digits: check_digits}) do
    Enum.concat([base, check_digits])
  end

  @impl true
  def to_string(cpf) do
    digits = to_digits(cpf)

    String.replace(Digits.to_string(digits), ~r/(\d{3})(\d{3})(\d{3})(\d{2})/, ~S"\1.\2.\3-\4")
  end

  @doc false
  def check_digits(base) do
    digit1 = Document.modulo11(Document.weighted_sum(base, 10..2))
    digit2 = Document.modulo11(Document.weighted_sum(base ++ [digit1], 11..2))

    [digit1, digit2]
  end

  defimpl String.Chars do
    defdelegate to_string(cnh), to: ParkingLot.Document.CPF
  end

  defimpl Inspect do
    def inspect(cpf, _opts) do
      Inspect.Algebra.concat(["#ParkingLot.Document.CPF<", to_string(cpf), ">"])
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(cpf) do
      to_string(cpf)
    end
  end
end
