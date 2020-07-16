defmodule PixelParty.GridCellComponent do
  use PixelPartyWeb, :live_component
  def render(assigns) do
    ~L"""
    <div id="<%= @x %>-<%= @y %>" class="grid-cell <%= @color %>"
    phx-click="click" phx-value-id="<%= @x %>,<%= @y %>"></div>
    """
  end
end
