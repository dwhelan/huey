defmodule Huey.Integration.ConnectionTest do
  use ExUnit.Case, asnyc: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Huey.Connection
  alias Huey.TestFixture, as: TF

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/connection")
    HTTPoison.start()
  end

  test "authorize creates a username" do
    use_cassette "authorize" do
      {:ok, connection} = Connection.authorize(TF.host(), "foobar")
      assert connection.bridge.username == TF.username()
    end
  end

  test "authorize warns to press the button when you forget!" do
    use_cassette "button_not_pressed" do
      {:error, message} = Connection.authorize(TF.host(), "foobar")
      assert message == "link button not pressed"
    end
  end
end
