defmodule Stela.ContractGen do
  require UtilityBelt.CodeGen.DynamicModule
  alias Stela.ContractGen.Helper
  alias UtilityBelt.CodeGen.DynamicModule

  @moduledoc """
  """

  preamble =
    quote do
    end

  stela_json =
    "artifacts/contracts/Stela.sol/Stela.json"
    |> File.read!()
    |> Poison.decode!()

  abi_list = stela_json["abi"]
  bytecode = stela_json["bytecode"]

  [constructor] = Enum.filter(abi_list, fn abi -> abi["type"] == "constructor" end)
  functions = Enum.filter(abi_list, fn abi -> abi["type"] == "function" end)

  contents = [
    Helper.quote_constructor(constructor, bytecode)
    | Enum.map(functions, &Helper.quote_function_call/1)
  ]

  DynamicModule.gen(
    "Stela.Contract",
    preamble,
    contents,
    doc: "This is an auto generated wraper module.",
    path: Path.join(File.cwd!(), "priv/gen")
  )
end
