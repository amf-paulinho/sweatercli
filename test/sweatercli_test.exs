defmodule SweatercliTest do
  use ExUnit.Case
  doctest Sweatercli

  test "greets the world" do
    assert Sweatercli.hello() == :world
  end
end