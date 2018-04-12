defmodule Huey do
  use Application

  def start(_type, _args) do
    Huey.Supervisor.start_link()
  end
end
