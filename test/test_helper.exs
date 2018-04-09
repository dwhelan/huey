ExUnit.start()

defmodule TestFixture do
  def host do
    "192.168.0.111"
  end

  def username do
    "FJtuwhryNZLot-HGCdn0KkV3A-T0m9ad1OmT-512"
  end

  def bridge do
    {:ok, bridge} = Huey.Bridge.connect(TestFixture.host(), TestFixture.username())
  end
end
