# LightBubble Relativity Calculator

A library for calculating time dilation effects in special and general relativity.

## Overview

This library provides functions to calculate time dilation in various relativistic scenarios:

- Special relativistic time dilation (due to velocity)
- Gravitational time dilation (due to gravity)
- Combined time dilation in curved spacetime

The calculations are based on the equations of special and general relativity, including the use of tensor mathematics for curved spacetime calculations.

## Installation

The package can be installed by adding `light_bubble` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:light_bubble, "~> 0.1.0"}
  ]
end
```

## Usage

### Livebook

For an interactive exploration of the LightBubble library, you can use the included Livebook:

```bash
# Install Livebook if you don't have it already
mix escript.install hex livebook

# Run the Livebook server
livebook server

# Then open the relativity_explorer.livemd file from the notebooks directory
```

> **Note**: The Livebook uses a git dependency to import the LightBubble modules directly from the GitHub repository, so you don't need to compile the application locally.

The Livebook provides:

- Interactive examples of all relativity calculations
- Visualizations of time dilation effects
- Real-world applications of relativity
- Advanced spacetime metric explorations

### Basic Usage

```elixir
# Start an IEx session with the application
$ iex -S mix

# Example usage for special relativistic time dilation
iex> velocity = 0.5 * LightBubble.Relativity.Constants.speed_of_light()
iex> observer_time = 10.0  # seconds
iex> LightBubble.Relativity.TimeDilation.calculate_special_relativistic_time(velocity, observer_time)
8.660254037844387  # proper time in seconds

# Example usage for gravitational time dilation
iex> mass = 5.972e24  # Earth's mass in kg
iex> radius = 6.371e6  # Earth's radius in meters
iex> observer_time = 10.0  # seconds
iex> LightBubble.Relativity.TimeDilation.calculate_gravitational_time(mass, radius, observer_time)
9.999999993024238  # proper time in seconds

# Example usage for general relativistic time dilation in curved spacetime
iex> velocity = 0.3 * LightBubble.Relativity.Constants.speed_of_light()
iex> mass = 5.972e24  # Earth's mass in kg
iex> radius = 6.371e6  # Earth's radius in meters
iex> observer_time = 10.0  # seconds
iex> LightBubble.Relativity.TimeDilation.calculate_proper_time(velocity, mass, radius, observer_time)
9.539392014169456  # proper time in seconds
```

### Advanced Usage with Custom Metrics

For advanced users who want to specify their own spacetime metrics:

```elixir
# Define a custom velocity vector [vx, vy, vz] in m/s
iex> velocity_vector = [1.0e7, 0.0, 0.0]  # 10,000 km/s in x direction
iex> metric = LightBubble.Relativity.Spacetime.minkowski_metric()  # Flat spacetime
iex> observer_time = 10.0  # seconds
iex> LightBubble.Relativity.TimeDilation.calculate_proper_time_with_metric(velocity_vector, metric, observer_time)
9.998889440734373  # proper time in seconds
```

## Modules

### LightBubble.Relativity.Constants

Provides fundamental physical constants required for relativity calculations:

- `speed_of_light/0`: Speed of light in vacuum (m/s)
- `gravitational_constant/0`: Gravitational constant (m³/kg·s²)
- `planck_constant/0`: Planck constant (J·s)
- `reduced_planck_constant/0`: Reduced Planck constant (ħ = h/2π) (J·s)

### LightBubble.Relativity.Spacetime

Provides functions to define and manipulate spacetime metrics:

- `minkowski_metric/0`: Creates a Minkowski metric tensor for flat spacetime
- `schwarzschild_metric/4`: Creates a Schwarzschild metric tensor for curved spacetime around a massive object
- `kerr_metric/4`: Creates a Kerr metric tensor for spacetime around a rotating black hole
- `morris_thorne_metric/3`: Creates a Morris-Thorne metric tensor for a traversable wormhole
- `flrw_metric/4`: Creates a Friedmann-Lemaître-Robertson-Walker metric tensor for an expanding universe
- `proper_time_interval/2`: Calculates the proper time interval using a metric tensor and coordinate differentials
- `calculate_proper_time/4`: Calculates the proper time for an object moving in a gravitational field

### LightBubble.Relativity.TimeDilation

Provides the main interface for time dilation calculations:

- `calculate_special_relativistic_time/2`: Calculates time dilation due to velocity (special relativity)
- `calculate_gravitational_time/3`: Calculates time dilation due to gravity (general relativity)
- `calculate_proper_time/4`: Calculates combined time dilation due to both velocity and gravity
- `calculate_proper_time_with_metric/3`: Calculates proper time using a custom metric tensor

## Physics Background

### Special Relativistic Time Dilation

In special relativity, time dilation occurs due to relative motion between observers. The formula is:

```
Δt' = Δt / γ
```

where:

- Δt is the time measured by a stationary observer
- Δt' is the proper time measured by the moving observer
- γ (gamma) is the Lorentz factor: γ = 1 / √(1 - v²/c²)
- v is the relative velocity
- c is the speed of light

### Gravitational Time Dilation

In general relativity, time dilation also occurs due to gravitational fields. The formula for weak gravitational fields is:

```
Δt' = Δt × √(1 - 2GM/rc²)
```

where:

- Δt is the time measured by an observer far from the gravitational source
- Δt' is the proper time measured by an observer in the gravitational field
- G is the gravitational constant
- M is the mass of the gravitating body
- r is the distance from the center of the gravitating body
- c is the speed of light

### General Relativistic Time Dilation

For curved spacetime, proper time is calculated using the metric tensor:

```
dτ² = gμν dx^μ dx^ν
```

where:

- dτ is the proper time interval
- gμν is the metric tensor
- dx^μ and dx^ν are coordinate differentials

## License

This project is licensed under the MIT License.
