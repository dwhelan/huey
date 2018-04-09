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

  def fact(n) do
    do_fact(n, 1)
  end

  defp do_fact(0, acc) do
    acc
  end

  defp do_fact(n, acc) do
    do_fact(n-1, n * acc)
  end
end
