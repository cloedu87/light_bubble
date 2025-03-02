defmodule LightBubble.Relativity.Constants do
  @moduledoc """
  Physical constants used in relativity calculations.

  This module provides fundamental physical constants required for
  calculations related to special and general relativity.
  """

  @doc """
  Speed of light in vacuum in meters per second.

  ## Examples

      iex> LightBubble.Relativity.Constants.speed_of_light()
      299792458.0

  """
  def speed_of_light, do: 299_792_458.0

  @doc """
  Gravitational constant in m³/(kg·s²).

  ## Examples

      iex> LightBubble.Relativity.Constants.gravitational_constant()
      6.67430e-11

  """
  def gravitational_constant, do: 6.67430e-11

  @doc """
  Planck constant in J·s.

  ## Examples

      iex> LightBubble.Relativity.Constants.planck_constant()
      6.62607015e-34

  """
  def planck_constant, do: 6.62607015e-34

  @doc """
  Reduced Planck constant (ħ = h/2π) in J·s.

  ## Examples

      iex> LightBubble.Relativity.Constants.reduced_planck_constant()
      1.0545718176461565e-34

  """
  def reduced_planck_constant, do: planck_constant() / (2 * :math.pi())
end
