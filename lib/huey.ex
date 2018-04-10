defmodule Huey do
  use Application

  @name Huey

  def start(_type, _args) do
    Huey.Supervisor.start_link()
  end
end
