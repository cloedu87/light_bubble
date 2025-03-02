defmodule LightBubble.Relativity.SpacetimeTest do
  use ExUnit.Case, async: true
  doctest LightBubble.Relativity.Spacetime

  alias LightBubble.Relativity.Spacetime
  alias LightBubble.Relativity.Constants

  describe "minkowski_metric/0" do
    test "returns a 4x4 tensor with correct values" do
      metric = Spacetime.minkowski_metric()
      assert Nx.shape(metric) == {4, 4}

      # Check diagonal elements
      assert Nx.to_number(metric[0][0]) == -1.0
      assert Nx.to_number(metric[1][1]) == 1.0
      assert Nx.to_number(metric[2][2]) == 1.0
      assert Nx.to_number(metric[3][3]) == 1.0

      # Check off-diagonal elements (should be 0)
      assert Nx.to_number(metric[0][1]) == 0.0
      assert Nx.to_number(metric[1][2]) == 0.0
      assert Nx.to_number(metric[2][3]) == 0.0
    end
  end

  describe "schwarzschild_metric/4" do
    test "returns a 4x4 tensor with correct structure" do
      # Earth's mass in kg
      mass = 5.972e24
      # Earth's radius in meters
      r = 6.371e6
      theta = :math.pi() / 2
      phi = 0.0

      metric = Spacetime.schwarzschild_metric(mass, r, theta, phi)
      assert Nx.shape(metric) == {4, 4}

      # Check that off-diagonal elements are zero
      assert Nx.to_number(metric[0][1]) == 0.0
      assert Nx.to_number(metric[1][2]) == 0.0
      assert Nx.to_number(metric[2][3]) == 0.0
    end

    test "calculates correct metric components for Earth" do
      # Earth's mass in kg
      mass = 5.972e24
      # Earth's radius in meters
      r = 6.371e6
      theta = :math.pi() / 2
      phi = 0.0

      c = Constants.speed_of_light()
      g = Constants.gravitational_constant()
      # Schwarzschild radius
      rs = 2 * g * mass / (c * c)

      expected_g_tt = -(1 - rs / r)
      expected_g_rr = 1 / (1 - rs / r)
      expected_g_theta_theta = r * r
      # sin²(π/2) = 1
      expected_g_phi_phi = r * r

      metric = Spacetime.schwarzschild_metric(mass, r, theta, phi)

      # For small values, use absolute tolerance
      assert_in_delta Nx.to_number(metric[0][0]), expected_g_tt, 1.0e-8
      assert_in_delta Nx.to_number(metric[1][1]), expected_g_rr, 1.0e-8

      # For large values (r^2), use relative tolerance with a higher delta
      assert_in_delta Nx.to_number(metric[2][2]) / expected_g_theta_theta, 1.0, 1.0e-7
      assert_in_delta Nx.to_number(metric[3][3]) / expected_g_phi_phi, 1.0, 1.0e-7
    end
  end

  describe "proper_time_interval/2" do
    test "calculates correct proper time for time-like interval in flat spacetime" do
      metric = Spacetime.minkowski_metric()
      # Time-like interval of 1 second
      dx = Nx.tensor([1.0, 0.0, 0.0, 0.0])

      proper_time = Spacetime.proper_time_interval(metric, dx)
      assert_in_delta Nx.to_number(proper_time), 1.0, 1.0e-6
    end

    test "calculates correct proper time for space-like interval in flat spacetime" do
      metric = Spacetime.minkowski_metric()
      # Space-like interval of 1 meter
      dx = Nx.tensor([0.0, 1.0, 0.0, 0.0])

      proper_time = Spacetime.proper_time_interval(metric, dx)
      assert_in_delta Nx.to_number(proper_time), 1.0, 1.0e-6
    end
  end

  describe "calculate_proper_time/4" do
    test "proper time is less than coordinate time for moving objects" do
      velocity = 0.5 * Constants.speed_of_light()
      # Earth's mass
      mass = 5.972e24
      # Earth's radius
      r = 6.371e6
      coordinate_time = 10.0

      proper_time = Spacetime.calculate_proper_time(velocity, mass, r, coordinate_time)
      assert proper_time < coordinate_time
    end

    test "proper time equals coordinate time for stationary objects far from gravity" do
      velocity = 0.0
      mass = 0.0
      # Very far from any mass
      r = 1.0e20
      coordinate_time = 10.0

      proper_time = Spacetime.calculate_proper_time(velocity, mass, r, coordinate_time)
      assert_in_delta proper_time, coordinate_time, 1.0e-10
    end

    test "calculates correct time dilation for special relativity" do
      velocity = 0.6 * Constants.speed_of_light()
      # No gravitational effects
      mass = 0.0
      # Very far from any mass
      r = 1.0e20
      coordinate_time = 10.0

      # Special relativistic time dilation formula
      expected =
        coordinate_time *
          :math.sqrt(
            1 - velocity * velocity / (Constants.speed_of_light() * Constants.speed_of_light())
          )

      proper_time = Spacetime.calculate_proper_time(velocity, mass, r, coordinate_time)
      assert_in_delta proper_time, expected, 1.0e-10
    end

    test "calculates correct time dilation for general relativity" do
      # No velocity effects
      velocity = 0.0
      # Earth's mass
      mass = 5.972e24
      # Earth's radius
      r = 6.371e6
      coordinate_time = 10.0

      c = Constants.speed_of_light()
      g = Constants.gravitational_constant()
      rs = 2 * g * mass / (c * c)

      # General relativistic time dilation formula
      expected = coordinate_time * :math.sqrt(1 - rs / r)

      proper_time = Spacetime.calculate_proper_time(velocity, mass, r, coordinate_time)
      assert_in_delta proper_time, expected, 1.0e-10
    end
  end

  describe "kerr_metric/4" do
    test "returns a 4x4 tensor with correct structure" do
      # Black hole mass (solar mass in kg)
      mass = 1.989e30
      # Angular momentum
      angular_momentum = 1.0e40
      r = 3.0e3
      theta = :math.pi() / 2

      metric = Spacetime.kerr_metric(mass, angular_momentum, r, theta)
      assert Nx.shape(metric) == {4, 4}

      # Check that specific off-diagonal elements are non-zero (t-phi and phi-t)
      assert Nx.to_number(metric[0][3]) != 0.0
      assert Nx.to_number(metric[3][0]) != 0.0

      # Check that other off-diagonal elements are zero
      assert Nx.to_number(metric[0][1]) == 0.0
      assert Nx.to_number(metric[0][2]) == 0.0
      assert Nx.to_number(metric[1][2]) == 0.0
      assert Nx.to_number(metric[1][3]) == 0.0
      assert Nx.to_number(metric[2][3]) == 0.0
    end

    test "calculates correct metric components for a rotating black hole" do
      # Black hole mass (solar mass in kg)
      mass = 1.989e30
      # Angular momentum
      angular_momentum = 1.0e40
      r = 3.0e3
      theta = :math.pi() / 2

      c = Constants.speed_of_light()
      g = Constants.gravitational_constant()
      rs = 2 * g * mass / (c * c)
      a = angular_momentum / (mass * c)

      rho_squared = r * r + a * a * :math.cos(theta) * :math.cos(theta)
      delta = r * r - rs * r + a * a

      expected_g_tt = -(1 - rs * r / rho_squared)
      expected_g_tphi = -rs * r * a * :math.sin(theta) * :math.sin(theta) / rho_squared
      expected_g_rr = rho_squared / delta
      expected_g_theta_theta = rho_squared

      expected_g_phi_phi =
        (r * r + a * a + rs * r * a * a * :math.sin(theta) * :math.sin(theta) / rho_squared) *
          :math.sin(theta) * :math.sin(theta)

      expected_g_phi_t = expected_g_tphi

      metric = Spacetime.kerr_metric(mass, angular_momentum, r, theta)

      # For small values, use absolute tolerance with appropriate delta
      assert_in_delta Nx.to_number(metric[0][0]), expected_g_tt, 1.0e-8
      assert_in_delta Nx.to_number(metric[0][3]), expected_g_tphi, 1.0e-6
      assert_in_delta Nx.to_number(metric[1][1]), expected_g_rr, 1.0e-5
      assert_in_delta Nx.to_number(metric[3][0]), expected_g_phi_t, 1.0e-6

      # For large values, use relative tolerance
      assert_in_delta Nx.to_number(metric[2][2]) / expected_g_theta_theta, 1.0, 1.0e-7
      assert_in_delta Nx.to_number(metric[3][3]) / expected_g_phi_phi, 1.0, 1.0e-7
    end
  end

  describe "morris_thorne_metric/3" do
    test "returns a 4x4 tensor with correct structure" do
      throat_radius = 1.0e3
      r = 2.0e3
      theta = :math.pi() / 2

      metric = Spacetime.morris_thorne_metric(throat_radius, r, theta)
      assert Nx.shape(metric) == {4, 4}

      # Check that off-diagonal elements are zero
      assert Nx.to_number(metric[0][1]) == 0.0
      assert Nx.to_number(metric[0][2]) == 0.0
      assert Nx.to_number(metric[0][3]) == 0.0
      assert Nx.to_number(metric[1][2]) == 0.0
      assert Nx.to_number(metric[1][3]) == 0.0
      assert Nx.to_number(metric[2][3]) == 0.0
    end

    test "calculates correct metric components for a wormhole" do
      throat_radius = 1.0e3
      r = 2.0e3
      theta = :math.pi() / 2

      expected_g_tt = -1.0
      expected_g_rr = 1.0 / (1 - throat_radius / r)
      expected_g_theta_theta = r * r
      expected_g_phi_phi = r * r * :math.sin(theta) * :math.sin(theta)

      metric = Spacetime.morris_thorne_metric(throat_radius, r, theta)

      # For small values, use absolute tolerance
      assert_in_delta Nx.to_number(metric[0][0]), expected_g_tt, 1.0e-8
      assert_in_delta Nx.to_number(metric[1][1]), expected_g_rr, 1.0e-8

      # For large values, use relative tolerance
      assert_in_delta Nx.to_number(metric[2][2]) / expected_g_theta_theta, 1.0, 1.0e-7
      assert_in_delta Nx.to_number(metric[3][3]) / expected_g_phi_phi, 1.0, 1.0e-7
    end
  end

  describe "flrw_metric/4" do
    test "returns a 4x4 tensor with correct structure" do
      scale_factor = 1.0
      curvature = 0
      chi = 0.5
      theta = :math.pi() / 2

      metric = Spacetime.flrw_metric(scale_factor, curvature, chi, theta)
      assert Nx.shape(metric) == {4, 4}

      # Check that off-diagonal elements are zero
      assert Nx.to_number(metric[0][1]) == 0.0
      assert Nx.to_number(metric[0][2]) == 0.0
      assert Nx.to_number(metric[0][3]) == 0.0
      assert Nx.to_number(metric[1][2]) == 0.0
      assert Nx.to_number(metric[1][3]) == 0.0
      assert Nx.to_number(metric[2][3]) == 0.0
    end

    test "calculates correct metric components for a flat universe" do
      scale_factor = 1.0
      curvature = 0
      chi = 0.5
      theta = :math.pi() / 2

      expected_g_tt = -1.0
      expected_g_rr = scale_factor * scale_factor
      expected_g_theta_theta = scale_factor * scale_factor * chi * chi

      expected_g_phi_phi =
        scale_factor * scale_factor * chi * chi * :math.sin(theta) * :math.sin(theta)

      metric = Spacetime.flrw_metric(scale_factor, curvature, chi, theta)

      # For small values, use absolute tolerance with appropriate delta
      assert_in_delta Nx.to_number(metric[0][0]), expected_g_tt, 1.0e-8
      assert_in_delta Nx.to_number(metric[1][1]), expected_g_rr, 1.0e-6
      assert_in_delta Nx.to_number(metric[2][2]), expected_g_theta_theta, 1.0e-7
      assert_in_delta Nx.to_number(metric[3][3]), expected_g_phi_phi, 1.0e-7
    end

    test "calculates correct metric components for a closed universe" do
      scale_factor = 2.0
      curvature = 1
      chi = 0.3
      theta = :math.pi() / 2

      expected_g_tt = -1.0
      expected_g_rr = scale_factor * scale_factor / (1 - curvature * chi * chi)
      expected_g_theta_theta = scale_factor * scale_factor * chi * chi

      expected_g_phi_phi =
        scale_factor * scale_factor * chi * chi * :math.sin(theta) * :math.sin(theta)

      metric = Spacetime.flrw_metric(scale_factor, curvature, chi, theta)

      # For small values, use absolute tolerance with appropriate delta
      assert_in_delta Nx.to_number(metric[0][0]), expected_g_tt, 1.0e-8
      assert_in_delta Nx.to_number(metric[1][1]), expected_g_rr, 1.0e-6
      assert_in_delta Nx.to_number(metric[2][2]), expected_g_theta_theta, 1.0e-7
      assert_in_delta Nx.to_number(metric[3][3]), expected_g_phi_phi, 1.0e-7
    end
  end
end
