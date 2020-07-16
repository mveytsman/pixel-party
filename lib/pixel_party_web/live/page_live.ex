defmodule PixelPartyWeb.PageLive do
  use PixelPartyWeb, :live_view
  @impl true
  def render(assigns) do
    ~L"""
    <h1>Pixel Party</h1>
    <div id="last_clicked">Last clicked: <%= inspect @last_clicked %></div>
      <div id="grid" class="grid" phx-update="append">
        <%= for y <- 0..(@height-1), x <- 0..(@width-1), Map.has_key?(@render_grid, {x,y}) do %>
        <div id="<%= x %>-<%= y %>" class="grid-cell <%= @render_grid[{x,y}] %>"
        phx-click="click" phx-value-id="<%= x %>,<%= y %>"></div>
        <% end %>
      </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    width = 30
    height = 25
    grid = PixelParty.Grid.viewport({0, 0}, width, height)

    {:ok,
     assign(socket,
       width: width,
       height: height,
       render_grid: grid,
       last_clicked: nil,
       last_color: :black
     ), temporary_assigns: [render_grid: %{}]}
  end

  def handle_event(
        "click",
        %{"id" => id},
        %{assigns: %{last_clicked: last_clicked, last_color: last_color}} = socket
      ) do
    pos = id |> String.split(",") |> Enum.map(&String.to_integer(&1)) |> List.to_tuple()

    color =
      if last_clicked != pos do
        PixelParty.Grid.change_color(pos, last_color)
      else
        PixelParty.Grid.change_color(pos)
      end

    {:noreply,
     assign(socket, :last_clicked, pos)
     |> assign(:render_grid, %{pos => color})
     |> assign(:last_color, color)}
  end
end
