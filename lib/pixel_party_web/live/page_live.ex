defmodule PixelPartyWeb.PageLive do
  use PixelPartyWeb, :live_view
  @impl true
  def render(assigns) do
    ~L"""
    <div id="last_clicked">Last clicked: <%= inspect @last_clicked %></div>
      <div id="grid" class="grid">
        <%= for y <- 0..(@height-1), x <- 0..(@height-1) do %>
          <div id="<%= x %>,<%= y %>" class="grid-cell <%= @grid[{x,y}] %>"
              phx-click="click" phx-value-id="<%= x %>,<%= y %>"></div>
        <% end %>
      </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    width = 30
    height = 30
    grid = for x <- 0..(width - 1), y <- 0..(height - 1), into: %{}, do: {{x, y}, :white}

    {:ok,
     assign(socket,
       width: width,
       height: height,
       grid: grid,
       last_clicked: nil,
       last_color: :black
     )}
  end

  def handle_event(
        "click",
        %{"id" => id},
        %{assigns: %{last_clicked: last_clicked, last_color: last_color, grid: grid}} = socket
      ) do
    id = id |> String.split(",") |> Enum.map(&String.to_integer(&1)) |> List.to_tuple()

    color =
      if last_clicked != id do
        last_color
      else
        next_color(grid[id])
      end

    {:noreply,
     assign(socket, :last_clicked, id)
     |> assign(:grid, Map.put(grid, id, color))
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
