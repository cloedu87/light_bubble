defmodule LightBubble.Relativity.Spacetime do
  @moduledoc """
  Spacetime metrics for relativity calculations.

  This module provides functions to define and manipulate spacetime metrics
  used in general relativity calculations.
  """

  alias LightBubble.Relativity.Constants
  import Nx.Defn

  @doc """
  Creates a Minkowski metric tensor for flat spacetime.

  The Minkowski metric is a 4x4 diagonal matrix with elements (-1, 1, 1, 1).
  It represents the spacetime of special relativity.

  ## Examples

      iex> metric = LightBubble.Relativity.Spacetime.minkowski_metric()
      iex> Nx.shape(metric)
      {4, 4}
      iex> Nx.to_flat_list(metric)
      [-1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0]

  """
  def minkowski_metric do
    Nx.tensor([
      [-1.0, 0.0, 0.0, 0.0],
      [0.0, 1.0, 0.0, 0.0],
      [0.0, 0.0, 1.0, 0.0],
      [0.0, 0.0, 0.0, 1.0]
    ])
  end

  @doc """
  Creates a Schwarzschild metric tensor for curved spacetime around a massive object.

  The Schwarzschild metric describes the spacetime geometry around a non-rotating,
  spherically symmetric mass.

  ## Parameters

    * `mass` - Mass of the central object in kilograms
    * `r` - Radial distance from the center in meters
    * `theta` - Polar angle in radians
    * `phi` - Azimuthal angle in radians

  ## Examples

      iex> mass = 5.972e24  # Earth's mass in kg
      iex> r = 6.371e6      # Earth's radius in meters
      iex> theta = :math.pi() / 2
      iex> phi = 0.0
      iex> metric = LightBubble.Relativity.Spacetime.schwarzschild_metric(mass, r, theta, phi)
      iex> Nx.shape(metric)
      {4, 4}

  """
  def schwarzschild_metric(mass, r, theta, _phi) do
    c = Constants.speed_of_light()
    g = Constants.gravitational_constant()
    # Schwarzschild radius
    rs = 2 * g * mass / (c * c)

    # Calculate metric components
    g_tt = -(1 - rs / r)
    g_rr = 1 / (1 - rs / r)
    g_theta_theta = r * r
    g_phi_phi = r * r * :math.sin(theta) * :math.sin(theta)

    Nx.tensor([
      [g_tt, 0.0, 0.0, 0.0],
      [0.0, g_rr, 0.0, 0.0],
      [0.0, 0.0, g_theta_theta, 0.0],
      [0.0, 0.0, 0.0, g_phi_phi]
    ])
  end

  @doc """
  Calculates the proper time interval using a metric tensor and coordinate differentials.

  ## Parameters

    * `metric` - The metric tensor as a 4x4 Nx tensor
    * `dx` - The coordinate differentials as a 4-element Nx tensor [dt, dx, dy, dz]

  ## Examples

      iex> metric = LightBubble.Relativity.Spacetime.minkowski_metric()
      iex> dx = Nx.tensor([1.0, 0.0, 0.0, 0.0])  # Time-like interval of 1 second
      iex> result = LightBubble.Relativity.Spacetime.proper_time_interval(metric, dx)
      iex> Nx.to_number(result)
      1.0

  """
  defn proper_time_interval(metric, dx) do
    # Calculate ds² = g_μν dx^μ dx^ν using tensor contraction
    # Instead of using Nx.dot directly, we'll implement the contraction manually
    # to avoid the Range.new warning

    # Initialize result to 0
    result = Nx.tensor(0.0)

    # Manually compute the contraction
    result = result + metric[0][0] * dx[0] * dx[0]
    result = result + metric[0][1] * dx[0] * dx[1]
    result = result + metric[0][2] * dx[0] * dx[2]
    result = result + metric[0][3] * dx[0] * dx[3]

    result = result + metric[1][0] * dx[1] * dx[0]
    result = result + metric[1][1] * dx[1] * dx[1]
    result = result + metric[1][2] * dx[1] * dx[2]
    result = result + metric[1][3] * dx[1] * dx[3]

    result = result + metric[2][0] * dx[2] * dx[0]
    result = result + metric[2][1] * dx[2] * dx[1]
    result = result + metric[2][2] * dx[2] * dx[2]
    result = result + metric[2][3] * dx[2] * dx[3]

    result = result + metric[3][0] * dx[3] * dx[0]
    result = result + metric[3][1] * dx[3] * dx[1]
    result = result + metric[3][2] * dx[3] * dx[2]
    result = result + metric[3][3] * dx[3] * dx[3]

    # Proper time is sqrt(-ds²) for timelike intervals
    Nx.sqrt(Nx.abs(result))
  end

  @doc """
  Calculates the proper time for an object moving in a gravitational field.

  ## Parameters

    * `velocity` - Velocity of the object in m/s
    * `mass` - Mass of the gravitating body in kg
    * `r` - Distance from the center of the gravitating body in meters
    * `coordinate_time` - Time measured by a distant observer in seconds

  ## Examples

      iex> velocity = 1000.0  # 1000 m/s
      iex> mass = 5.972e24    # Earth's mass in kg
      iex> r = 6.371e6        # Earth's radius in meters
      iex> coordinate_time = 10.0  # 10 seconds
      iex> proper_time = LightBubble.Relativity.Spacetime.calculate_proper_time(velocity, mass, r, coordinate_time)
      iex> proper_time < coordinate_time
      true

  """
  def calculate_proper_time(velocity, mass, r, coordinate_time) do
    c = Constants.speed_of_light()
    g = Constants.gravitational_constant()

    # Time dilation factor due to velocity (special relativity)
    gamma_v = 1 / :math.sqrt(1 - velocity * velocity / (c * c))

    # Time dilation factor due to gravity (general relativity)
    # Schwarzschild radius
    rs = 2 * g * mass / (c * c)
    gamma_g = :math.sqrt(1 - rs / r)

    # Combined time dilation
    proper_time = coordinate_time / (gamma_v / gamma_g)

    proper_time
  end
end
