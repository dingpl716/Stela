defmodule StelaTest do
  use ExUnit.Case
  doctest Stela

  test "greets the world" do
    assert Stela.hello() == :world
  end
end
