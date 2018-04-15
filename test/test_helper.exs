excludes = [:skip]

# Uncomment the line below to enable focus mode
#|> List.insert_at(0, :test)

ExUnit.start(include: :focus, exclude: excludes, capture_log: true)

defmodule TestFixture do
  def host do
    "192.168.0.111"
  end

  def username do
    "FJtuwhryNZLot-HGCdn0KkV3A-T0m9ad1OmT-512"
  end

  def connection(huex \\ Huex) do
    %Huey.Connection{bridge: bridge(), huex: huex}
  end

  def bridge do
    {:ok, bridge} = Huey.Bridge.connect(TestFixture.host(), TestFixture.username())
    bridge
  end

  def bridge_error(message) do
    %{
      status: :error,
      error: %{
        "description" => message
      }
    }
  end
end

defmodule Expectation do
  defstruct [:expect, :response]

  def expect(method, args) do
    %Expectation{
      expect: {method, args},
      response: %{
        status: :ok
      }
    }
  end

  def expect_error(method, args, error_message) do
    %Expectation{
      expect: {method, args},
      response: %{
        status: :error,
        error: %{
          "description" => error_message
        }
      }
    }
  end
end
