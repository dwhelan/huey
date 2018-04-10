defmodule Huey.Supervisor do

  @name :supervisor

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
      worker(Huey.Router, []),
      Huey.SceneServer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end