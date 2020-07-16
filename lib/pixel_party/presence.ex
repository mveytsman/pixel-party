defmodule PixelParty.Presence do
  use Phoenix.Presence,
    otp_app: :pixel_party,
    pubsub_server: PixelParty.PubSub
end
