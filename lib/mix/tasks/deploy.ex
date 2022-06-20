defmodule Mix.Tasks.Stela.Deploy do
  use Mix.Task

  def run([arg]) do
    Application.ensure_all_started(:ocap_rpc)
    deployer = Application.get_env(:stela, :accounts) |> Keyword.get(:deployer)

    do_run(arg, deployer)
  end

  def do_run("stela", {_, sk}) do
    hash = Stela.StelaContract.deploy(sk, 86400, "https://stela.ios")
    tx = wait_tx(hash) |> IO.inspect()
    contract = get_contract_address(tx)

    Stela.StelaContract.symbol(contract)
    |> IO.inspect(label: "symbol")

    # Stela.SimpleAuctionContract.beneficiary(contract) |> IO.inspect(label: "beneficiary")
  end

  def do_run("auction", {address, sk}) do
    token_id = 1
    bidding_time = 86400
    beneficiary_address = address
    min_bid_wei = 100_000

    hash =
      Stela.SimpleAuctionContract.deploy(
        sk,
        token_id,
        bidding_time,
        beneficiary_address,
        min_bid_wei
      )

    tx = wait_tx(hash) |> IO.inspect()
    contract = get_contract_address(tx)

    Stela.SimpleAuctionContract.auction_token_id(contract)
    |> IO.inspect(label: "auction_token_id")

    Stela.SimpleAuctionContract.auction_end_time(contract)
    |> IO.inspect(label: "auction_end_time")
  end

  defp get_contract_address(tx) do
    [trace] = tx.traces
    trace.result_address
  end

  defp wait_tx(hash) do
    wait_tx(hash, OcapRpc.Eth.Transaction.get_by_hash(hash))
  end

  defp wait_tx(hash, nil) do
    Process.sleep(1000)
    tx = OcapRpc.Eth.Transaction.get_by_hash(hash)
    wait_tx(hash, tx)
  end

  defp wait_tx(_hash, tx) do
    tx
  end
end
