defmodule Huey do
  use Application

  @name Huey

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Huey.Router, [])
    ]

    opts = [strategy: :one_for_one, name: @name]
    Supervisor.start_link(children, opts)
  end
end
