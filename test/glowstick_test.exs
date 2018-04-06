defmodule GlowstickTest do
  use ExUnit.Case
  doctest Glowstick

  test "greets the world" do
    assert Glowstick.hello() == :world
  end
end
