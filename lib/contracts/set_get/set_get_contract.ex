defmodule EthContractSign.Contracts.SetGetContract do
  @moduledoc """
  This module is responsible for the smart contract interaction
  """

  alias EthContractSign.Contracts.ContractHelpers
  alias __MODULE__

  use Ethers.Contract,
    abi_file: "lib/contracts/set_get/set_get_contract.json",
    default_address: "0x79faE3888ce11F932E4e01E94e768eE179F00d26"

  def store(value, address, private_key) do
    raw_tx = %{
      "to" => contract_address(),
      "gas_price" => gas_price(1.5),
      "sender" => address,
      "nonce" => address |> SignWeb3.get_tx_count() |> ContractHelpers.parse_results(),
      "fav" => {"store", ["uint256"], [to_string(value)]}
    }

    ContractHelpers.sign_and_send_tx(private_key, raw_tx)
  end

  @doc """
  This function deals with fetching the conversion prices temporarily
  """
  def get_price() do
    {:ok, [price]} = SetGetContract.retrieve()

    to_string(price) <> ".0"
  end

  @doc """
  This function deals with fetching the contract address
  """
  def contract_address do
    __MODULE__.default_address()
  end

  defp gas_price(multiplier) do
    ContractHelpers.get_gas_price(multiplier)
  end

  ## Just for testing
  def pri_11 do
    [
      113,
      57,
      71,
      82,
      18,
      105,
      2,
      1,
      197,
      106,
      240,
      86,
      151,
      126,
      57,
      18,
      20,
      237,
      0,
      125,
      26,
      188,
      140,
      66,
      247,
      16,
      163,
      210,
      33,
      189,
      88,
      230
    ]
  end

  def address_1 do
    "0x5B15e7CFC58a053870870a6E927B21d76D46BF7a"
  end
end
