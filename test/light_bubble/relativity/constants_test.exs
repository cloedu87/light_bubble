defmodule LightBubble.Relativity.ConstantsTest do
  use ExUnit.Case, async: true
  doctest LightBubble.Relativity.Constants

  alias LightBubble.Relativity.Constants

  describe "physical constants" do
    test "speed_of_light returns the correct value" do
      assert Constants.speed_of_light() == 299_792_458.0
    end

    test "gravitational_constant returns the correct value" do
      assert Constants.gravitational_constant() == 6.67430e-11
    end

    test "planck_constant returns the correct value" do
      assert Constants.planck_constant() == 6.62607015e-34
    end

    test "reduced_planck_constant returns h/2π" do
      expected = Constants.planck_constant() / (2 * :math.pi())
      assert Constants.reduced_planck_constant() == expected
    end
  end
end
