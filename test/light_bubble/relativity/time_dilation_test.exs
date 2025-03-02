defmodule LightBubble.Relativity.TimeDilationTest do
  use ExUnit.Case, async: true
  doctest LightBubble.Relativity.TimeDilation

  alias LightBubble.Relativity.TimeDilation
  alias LightBubble.Relativity.Constants
  alias LightBubble.Relativity.Spacetime

  describe "calculate_special_relativistic_time/2" do
    test "proper time is less than observer time for moving objects" do
      velocity = 0.5 * Constants.speed_of_light()
      observer_time = 10.0

      proper_time = TimeDilation.calculate_special_relativistic_time(velocity, observer_time)
      assert proper_time < observer_time
    end

    test "proper time equals observer time for stationary objects" do
      velocity = 0.0
      observer_time = 10.0

      proper_time = TimeDilation.calculate_special_relativistic_time(velocity, observer_time)
      assert_in_delta proper_time, observer_time, 1.0e-10
    end

    test "calculates correct time dilation for various velocities" do
      observer_time = 10.0
      c = Constants.speed_of_light()

      test_velocities = [
        0.1 * c,
        0.5 * c,
        0.9 * c
      ]

      for velocity <- test_velocities do
        expected = observer_time * :math.sqrt(1 - velocity * velocity / (c * c))
        actual = TimeDilation.calculate_special_relativistic_time(velocity, observer_time)
        assert_in_delta actual, expected, 1.0e-10
      end
    end
  end

  describe "calculate_gravitational_time/3" do
    test "proper time is less than observer time in gravitational field" do
      # Earth's mass
      mass = 5.972e24
      # Earth's radius
      r = 6.371e6
      observer_time = 10.0

      proper_time = TimeDilation.calculate_gravitational_time(mass, r, observer_time)
      assert proper_time < observer_time
    end

    test "proper time equals observer time far from gravitational sources" do
      mass = 0.0
      # Very far from any mass
      r = 1.0e20
      observer_time = 10.0

      proper_time = TimeDilation.calculate_gravitational_time(mass, r, observer_time)
      assert_in_delta proper_time, observer_time, 1.0e-10
    end

    test "calculates correct time dilation for various masses and distances" do
      observer_time = 10.0
      c = Constants.speed_of_light()
      g = Constants.gravitational_constant()

      test_cases = [
        # Earth at surface
        {5.972e24, 6.371e6},
        # Sun at surface
        {1.989e30, 6.96e8},
        # Earth from Moon distance
        {5.972e24, 3.844e8}
      ]

      for {mass, r} <- test_cases do
        rs = 2 * g * mass / (c * c)
        expected = observer_time * :math.sqrt(1 - rs / r)
        actual = TimeDilation.calculate_gravitational_time(mass, r, observer_time)
        assert_in_delta actual, expected, 1.0e-10
      end
    end
  end

  describe "calculate_proper_time/4" do
    test "delegates to Spacetime.calculate_proper_time/4" do
      velocity = 0.3 * Constants.speed_of_light()
      mass = 5.972e24
      r = 6.371e6
      observer_time = 10.0

      expected = Spacetime.calculate_proper_time(velocity, mass, r, observer_time)
      actual = TimeDilation.calculate_proper_time(velocity, mass, r, observer_time)

      assert actual == expected
    end

    test "proper time is less than observer time for combined effects" do
      velocity = 0.3 * Constants.speed_of_light()
      mass = 5.972e24
      r = 6.371e6
      observer_time = 10.0

      proper_time = TimeDilation.calculate_proper_time(velocity, mass, r, observer_time)
      assert proper_time < observer_time
    end
  end

  describe "calculate_proper_time_with_metric/3" do
    test "calculates correct proper time for stationary object in flat spacetime" do
      velocity_vector = [0.0, 0.0, 0.0]
      metric = Spacetime.minkowski_metric()
      observer_time = 10.0

      proper_time =
        TimeDilation.calculate_proper_time_with_metric(velocity_vector, metric, observer_time)

      assert_in_delta proper_time, observer_time, 1.0e-10
    end

    test "calculates correct proper time for moving object in flat spacetime" do
      c = Constants.speed_of_light()
      velocity = 0.5 * c
      velocity_vector = [velocity, 0.0, 0.0]
      metric = Spacetime.minkowski_metric()
      observer_time = 10.0

      # Expected time dilation from special relativity
      expected = observer_time * :math.sqrt(1 - velocity * velocity / (c * c))

      proper_time =
        TimeDilation.calculate_proper_time_with_metric(velocity_vector, metric, observer_time)

      assert_in_delta proper_time, expected, 1.0e-6
    end

    test "calculates correct proper time for object in Schwarzschild spacetime" do
      # Stationary
      velocity_vector = [0.0, 0.0, 0.0]
      # Earth's mass
      mass = 5.972e24
      # Earth's radius
      r = 6.371e6
      theta = :math.pi() / 2
      phi = 0.0
      observer_time = 10.0

      metric = Spacetime.schwarzschild_metric(mass, r, theta, phi)

      # Expected time dilation from general relativity
      c = Constants.speed_of_light()
      g = Constants.gravitational_constant()
      rs = 2 * g * mass / (c * c)
      expected = observer_time * :math.sqrt(1 - rs / r)

      proper_time =
        TimeDilation.calculate_proper_time_with_metric(velocity_vector, metric, observer_time)

      assert_in_delta proper_time, expected, 1.0e-6
    end
  end
end
