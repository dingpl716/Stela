defmodule Stela do
  @moduledoc """
  Documentation for `Stela`.
  """

  @doc """
  Gets the corresponding Ethereum address from the `private_key`.

  ## Examples

    iex> Stela.get_address_from_private_key("0x9f815bb1f5de9cf240235b3e54839dcf6673bb48a2cfbeecda14613f1ea48765")
    "0xfb597fa80538b61c1be2434b0dcdc73df06d4a82"
  """
  defdelegate get_address_from_private_key(private_key_str),
    to: OcapRpc.Internal.EthTransaction.Helper
end
