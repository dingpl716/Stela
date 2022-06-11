defmodule Stela.Util do
  def ensure_no_hex("0x" <> hex), do: Base.decode16!(hex, case: :mixed)
  def ensure_no_hex(var), do: var
end
