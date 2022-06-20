defmodule Stela.ContractGen do
  alias Stela.ContractGen.Helper

  @moduledoc """
  """

  [
    {"artifacts/contracts/Stela.sol/Stela.json", "Stela.StelaContract"},
    {"artifacts/contracts/SimpleAuction.sol/SimpleAuction.json", "Stela.SimpleAuctionContract"}
  ]
  |> Enum.map(fn {path, name} -> Helper.gen_contract(path, name) end)
end
