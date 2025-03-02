defmodule LightBubble.Relativity.TimeDilation do
  @moduledoc """
  Time dilation calculations for special and general relativity.

  This module provides functions to calculate time dilation effects
  in various relativistic scenarios, including:

  - Special relativistic time dilation (due to velocity)
  - Gravitational time dilation (due to gravity)
  - Combined time dilation in curved spacetime

  The calculations are based on the equations of special and general relativity.
  """

  alias LightBubble.Relativity.Constants
  alias LightBubble.Relativity.Spacetime

  @doc """
  Calculates time dilation due to velocity (special relativity).

  This function calculates the proper time experienced by an object moving
  at a given velocity, as measured by the object itself, compared to the
  coordinate time measured by a stationary observer.

  ## Parameters

    * `velocity` - Velocity of the object in m/s
    * `observer_time` - Time measured by a stationary observer in seconds

  ## Examples

      iex> velocity = 0.5 * LightBubble.Relativity.Constants.speed_of_light()
      iex> observer_time = 10.0
      iex> proper_time = LightBubble.Relativity.TimeDilation.calculate_special_relativistic_time(velocity, observer_time)
      iex> proper_time < observer_time
      true

  """
  def calculate_special_relativistic_time(velocity, observer_time) do
    c = Constants.speed_of_light()

    # Time dilation factor (gamma)
    gamma = 1 / :math.sqrt(1 - velocity * velocity / (c * c))

    # Proper time = observer time / gamma
    observer_time / gamma
  end

  @doc """
  Calculates time dilation due to gravity (general relativity).

  This function calculates the proper time experienced by an object in a
  gravitational field, as measured by the object itself, compared to the
  coordinate time measured by an observer far from the gravitational source.

  ## Parameters

    * `mass` - Mass of the gravitating body in kg
    * `r` - Distance from the center of the gravitating body in meters
    * `observer_time` - Time measured by a distant observer in seconds

  ## Examples

      iex> mass = 5.972e24  # Earth's mass in kg
      iex> r = 6.371e6      # Earth's radius in meters
      iex> observer_time = 10.0
      iex> proper_time = LightBubble.Relativity.TimeDilation.calculate_gravitational_time(mass, r, observer_time)
      iex> proper_time < observer_time
      true

  """
  def calculate_gravitational_time(mass, r, observer_time) do
    c = Constants.speed_of_light()
    g = Constants.gravitational_constant()

    # Schwarzschild radius
    rs = 2 * g * mass / (c * c)

    # Time dilation factor due to gravity
    time_dilation_factor = :math.sqrt(1 - rs / r)

    # Proper time = observer time * time dilation factor
    observer_time * time_dilation_factor
  end

  @doc """
  Calculates combined time dilation due to both velocity and gravity.

  This function calculates the proper time experienced by an object moving
  at a given velocity in a gravitational field, as measured by the object itself,
  compared to the coordinate time measured by a distant observer.

  ## Parameters

    * `velocity` - Velocity of the object in m/s
    * `mass` - Mass of the gravitating body in kg
    * `r` - Distance from the center of the gravitating body in meters
    * `observer_time` - Time measured by a distant observer in seconds

  ## Examples

      iex> velocity = 0.3 * LightBubble.Relativity.Constants.speed_of_light()
      iex> mass = 5.972e24  # Earth's mass in kg
      iex> r = 6.371e6      # Earth's radius in meters
      iex> observer_time = 10.0
      iex> proper_time = LightBubble.Relativity.TimeDilation.calculate_proper_time(velocity, mass, r, observer_time)
      iex> proper_time < observer_time
      true

  """
  def calculate_proper_time(velocity, mass, r, observer_time) do
    Spacetime.calculate_proper_time(velocity, mass, r, observer_time)
  end

  @doc """
  Calculates proper time using a custom metric tensor.

  This function is for advanced users who want to specify their own
  spacetime metric for the calculation.

  ## Parameters

    * `velocity_vector` - 3-element vector [vx, vy, vz] in m/s
    * `metric_tensor` - 4x4 metric tensor as an Nx tensor
    * `observer_time` - Time measured by a distant observer in seconds

  ## Examples

      iex> velocity_vector = [0.0, 0.0, 0.0]  # Stationary object
      iex> metric = LightBubble.Relativity.Spacetime.minkowski_metric()
      iex> observer_time = 10.0
      iex> result = LightBubble.Relativity.TimeDilation.calculate_proper_time_with_metric(velocity_vector, metric, observer_time)
      iex> Float.round(result, 5)
      10.0

  """
  def calculate_proper_time_with_metric(velocity_vector, metric_tensor, observer_time) do
    c = Constants.speed_of_light()

    # Extract velocity components
    [vx, vy, vz] = velocity_vector
    # Calculate the magnitude of the velocity (for documentation purposes)
    _v_magnitude = :math.sqrt(vx * vx + vy * vy + vz * vz)

    # Create a 4-velocity vector (dt, dx, dy, dz)
    # For simplicity, we assume the object moves for 1 second of coordinate time
    dt = 1.0
    dx = vx * dt / c
    dy = vy * dt / c
    dz = vz * dt / c

    dx_tensor = Nx.tensor([dt, dx, dy, dz])

    # Calculate the proper time interval
    proper_time_interval = Spacetime.proper_time_interval(metric_tensor, dx_tensor)

    # Scale to the requested observer time
    # The proper_time_interval is already a scalar tensor, so we can use it directly
    observer_time * Nx.to_number(proper_time_interval)
  end
end
