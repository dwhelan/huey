excludes = [:skip]

# Uncomment the line below to enable focus mode
#|> List.insert_at(0, :test)

ExUnit.start(include: :focus, exclude: excludes, capture_log: true)

defmodule Huey.TestFixture do
  alias Huey.Connection
  alias Huex.Bridge

  def host do
    "192.168.0.111"
  end

  def username do
    "FJtuwhryNZLot-HGCdn0KkV3A-T0m9ad1OmT-512"
  end

  def connection(huex \\ Huex, %Bridge{} = bridge \\ bridge()) do
    %Connection{bridge: bridge, huex: huex}
  end

  def bridge do
    %Bridge{host: host(), username: username()}
  end

  def bridge_error(message) do
    %Bridge{
      status: :error,
      error: %{
        "description" => message
      }
    }
  end
end
