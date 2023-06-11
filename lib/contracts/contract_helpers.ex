defmodule EthContractSign.Contracts.ContractHelpers do
  @moduledoc """
  This the module that contains the helper functions for the contracts
  """
  require Logger
  @chain_id 5

  def sign_tx(private_key, raw_tx) do
    SignWeb3.sign_tx(private_key, raw_tx, @chain_id)
  end

  def sign_and_send_tx(private_key, raw_tx) do
    signed_tx = sign_tx(private_key, raw_tx)
    SignWeb3.send_tx("eth_sendRawTransaction", ["0x#{signed_tx}"])
  end

  @doc """
  This function is responsible for fetching the gas price & then it multiplies it with the required
  multiplier passed as an argument
  """
  @spec get_gas_price(integer | nil) :: {:ok, integer} | {:error, String.t()}
  def get_gas_price(multiple \\ 1) do
    SignWeb3.gas_price()
    |> parse_results()
    |> case do
      {:ok, price} ->
        price |> hex_to_integer() |> Kernel.*(multiple) |> integer_to_hex()

      error ->
        error
    end
  end

  defp hex_to_integer(value) do
    value
    |> String.slice(2..-1)
    |> String.to_integer(16)
  end

  defp integer_to_hex(value) do
    {value, _padding} =
      value
      |> to_string()
      |> Integer.parse()

    value = Integer.to_string(value, 16)
    "0x#{value}"
  end

  def parse_results(result) do
    case result do
      {:ok, data} ->
        {:ok, %{"result" => result}} = Jason.decode(data.body)
        result

      error ->
        Logger.error("Error while parsing data: #{inspect(error)}")
        {:error, "Error while parsing data: #{inspect(error)}"}
    end
  end
end
