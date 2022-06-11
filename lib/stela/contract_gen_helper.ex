defmodule Stela.ContractGen.Helper do
  def quote_constructor(abi, bytecode) do
    args = abi["inputs"] |> Enum.map(&Map.get(&1, "name")) |> Enum.map(&to_snake_atom/1)
    types = abi["inputs"] |> Enum.map(&Map.get(&1, "type")) |> Enum.join(",")
    func_sig = "(#{types})"

    quoted_args = [:private_key | args] |> Enum.map(&Macro.var(&1, nil))

    quote do
      def deploy(unquote_splicing(quoted_args)) do
        values =
          unquote(args)
          |> Enum.map(fn k -> Keyword.get(binding(), k) end)
          |> Enum.map(&Stela.Util.ensure_no_hex/1)

        input =
          unquote(bytecode) <>
            (unquote(func_sig)
             |> ABI.encode([List.to_tuple(values)])
             |> Base.encode16(case: :lower))

        k = Keyword.get(binding(), :private_key)
        OcapRpc.Eth.Transaction.send_transaction(k, nil, 0, input: input, gas_limit: 3_000_000)
      end
    end
  end

  @doc """
  An `abi` looks like this:
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "operator",
          "type": "address"
        }
      ],
      "name": "isApprovedForAll",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  """
  def quote_function_call(abi) do
    func_name = to_snake_atom(abi["name"])
    args = abi["inputs"] |> Enum.map(&Map.get(&1, "name")) |> Enum.map(&to_snake_atom/1)
    types = abi["inputs"] |> Enum.map(&Map.get(&1, "type")) |> Enum.join(",")
    func_sig = "#{abi["name"]}(#{types})"

    quote_function_call(abi["stateMutability"], func_name, args, func_sig)
  end

  # def is_approved_for_all(contract, owner, operator) do
  #   values = Enum.map([:owner, :operator], fn k -> Keyword.get(binding(), k) end)
  #   input = ABI.encode("isApprovedForAll(address,address)", values)
  #   c = Keyword.get(binding(), :contract)
  #   message = %{to: c, data: input}
  #   OcapRpc.Eth.Chain.call(message)
  # end
  defp quote_function_call("view", func_name, args, func_sig) do
    quoted_args = [:contract | args] |> Enum.map(&Macro.var(&1, nil))

    quote do
      def unquote(func_name)(unquote_splicing(quoted_args)) do
        values =
          unquote(args)
          |> Enum.map(fn k -> Keyword.get(binding(), k) end)
          |> Enum.map(&Stela.Util.ensure_no_hex/1)

        input = unquote(func_sig) |> ABI.encode(values) |> Base.encode16(case: :lower)
        c = Keyword.get(binding(), :contract)
        message = %{to: c, data: input}
        OcapRpc.Eth.Chain.call(message)
      end
    end
  end

  defp quote_function_call("nonpayable", func_name, args, func_sig) do
    quoted_args = [:contract, :private_key | args] |> Enum.map(&Macro.var(&1, nil))

    quote do
      def unquote(func_name)(unquote_splicing(quoted_args)) do
        values =
          unquote(args)
          |> Enum.map(fn k -> Keyword.get(binding(), k) end)
          |> Enum.map(&Stela.Util.ensure_no_hex/1)

        input = unquote(func_sig) |> ABI.encode(values) |> Base.encode16(case: :lower)
        c = Keyword.get(binding(), :contract)
        k = Keyword.get(binding(), :private_key)
        OcapRpc.Eth.Transaction.send_transaction(k, c, 0, input: input)
      end
    end
  end

  defp quote_function_call("payable", func_name, args, func_sig) do
    quoted_args = [:contract, :private_key, :wei | args] |> Enum.map(&Macro.var(&1, nil))

    quote do
      def unquote(func_name)(unquote_splicing(quoted_args)) do
        values =
          unquote(args)
          |> Enum.map(fn k -> Keyword.get(binding(), k) end)
          |> Enum.map(&Stela.Util.ensure_no_hex/1)

        input = unquote(func_sig) |> ABI.encode(values) |> Base.encode16(case: :lower)
        c = Keyword.get(binding(), :contract)
        k = Keyword.get(binding(), :private_key)
        w = Keyword.get(binding(), :wei)
        OcapRpc.Eth.Transaction.send_transaction(k, c, w, input: input)
      end
    end
  end

  @doc """
  Convert a string to an atom in snake case.

  ## Examples

    iex> Stela.ContractGen.Helper.to_snake_atom("getApproved")
    :get_approved

    iex> Stela.ContractGen.Helper.to_snake_atom("approved")
    :approved
  """
  def to_snake_atom(str) do
    str |> Macro.underscore() |> String.to_atom()
  end
end
