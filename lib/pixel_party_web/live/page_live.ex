defmodule PixelPartyWeb.PageLive do
  use PixelPartyWeb, :live_view
  @impl true
  def render(assigns) do
    ~L"""
      <div id="grid" class="grid">
        <%= for y <- 0..(@height-1), x <- 0..(@height-1) do %>
          <div id="<%= x %>,<%= y %>" class="grid-cell <%= @grid[{x,y}] %>"></div>
        <% end %>
      </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    width = 30
    height = 30
    grid = for x <- 0..(width-1), y <- 0..(height-1), into: %{}, do: {{x,y}, :white}
    {:ok, assign(socket, width: width, height: height, grid: grid)}
  end
end
