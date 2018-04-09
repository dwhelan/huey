defmodule Huey do
  @moduledoc """
  Documentation for Huey.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Huey.hello
      :world

  """
  def hello do
    :world
  end

  def fact(0) do
    1
  end

  def fact(n) do
    n * fact(n-1)
  end
end
