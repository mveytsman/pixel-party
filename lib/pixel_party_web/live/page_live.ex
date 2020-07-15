defmodule PixelPartyWeb.PageLive do
  use PixelPartyWeb, :live_view


  @impl true
  def render(assigns) do
    ~L"""
    <p>Hello World</p>
    """
  end
  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
