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
    grid = PixelParty.Grid.viewport({0,0}, width, height)

    {:ok,
     assign(socket,
       width: width,
       height: height,
       grid: grid,
       render_grid: grid,
       last_clicked: nil,
       last_color: :black
     ), temporary_assigns: [render_grid: %{}]}
  end

  def handle_event(
        "click",
        %{"id" => id},
        %{assigns: %{last_clicked: last_clicked, last_color: last_color, grid: grid}} = socket
      ) do
    pos = id |> String.split(",") |> Enum.map(&String.to_integer(&1)) |> List.to_tuple()

    color =
      if last_clicked != pos do
        last_color
      else
        next_color(grid[pos])
      end

    PixelParty.Grid.set(pos, color)

    {:noreply,
     assign(socket, :last_clicked, pos)
     |> assign(:grid, Map.put(grid, pos, color))
     |> assign(:render_grid, %{pos => color})
     |> assign(:last_color, color)}
  end

  def next_color(:white), do: :black
  def next_color(:black), do: :gray
  def next_color(:gray), do: :red
  def next_color(:red), do: :orange
  def next_color(:orange), do: :yellow
  def next_color(:yellow), do: :green
  def next_color(:green), do: :blue
  def next_color(:blue), do: :indigo
  def next_color(:indigo), do: :violet
  def next_color(:violet), do: :black
end
