defmodule PixelPartyWeb.PageLive do
  use PixelPartyWeb, :live_view
  @impl true
  def render(assigns) do
    ~L"""
    <h1>Pixel Party</h1>
    <p>Click to color, Arrows or WASD to move the screen!</p>
    <div id="debug">Origin: <%= inspect @origin %>, Last clicked: <%= inspect @last_clicked %>, Other players: <%= Enum.count(@presence) -1 %></div>
    <div id="grid" class="grid" phx-window-keydown="keydown">
      <%= for y <- 0..(@height-1), x <- 0..(@width-1), Map.has_key?(@render_grid, {x,y}) do %>
        <%= live_component @socket, PixelParty.GridCellComponent, id: {x,y}, x: x, y: y, color: @render_grid[{x,y}] %>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    width = 30
    height = 25
    origin = {0, 0}
    grid = PixelParty.Grid.viewport(origin, width, height)

    if connected?(socket) do
      Phoenix.PubSub.subscribe(PixelParty.PubSub, "grid")

      PixelParty.Presence.track(
        self(),
        "grid_presence",
        socket.id,
        %{}
      )

      Phoenix.PubSub.subscribe(PixelParty.PubSub, "grid_presence")
    end

    presence = PixelParty.Presence.list("grid_presence")

    {:ok,
     assign(socket,
       origin: origin,
       width: width,
       height: height,
       render_grid: grid,
       last_clicked: nil,
       last_color: :black,
       presence: presence
     ), temporary_assigns: [render_grid: %{}]}
  end

  @impl true
  def handle_event(
        "click",
        %{"id" => id},
        %{
          assigns: %{
            last_clicked: last_clicked,
            last_color: last_color,
            origin: {x_origin, y_origin}
          }
        } = socket
      ) do
    {x, y} = id |> String.split(",") |> Enum.map(&String.to_integer(&1)) |> List.to_tuple()

    pos = {x + x_origin, y + y_origin}

    color =
      if last_clicked != pos do
        PixelParty.Grid.change_color(pos, last_color)
      else
        PixelParty.Grid.change_color(pos)
      end

    {:noreply,
     assign(socket, :last_clicked, pos)
     #   |> assign(:render_grid, %{pos => color})
     |> assign(:last_color, color)}
  end

  def handle_event("keydown", %{"key" => key}, socket) do
    socket =
      case key do
        "ArrowRight" -> move(socket, :right)
        "ArrowLeft" -> move(socket, :left)
        "ArrowUp" -> move(socket, :up)
        "ArrowDown" -> move(socket, :right)
        "d" -> move(socket, :right)
        "a" -> move(socket, :left)
        "w" -> move(socket, :up)
        "s" -> move(socket, :down)
        _ -> socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {:color_changed, {x, y}, color},
        %{assigns: %{origin: {x_origin, y_origin}, width: width, height: height}} = socket
      ) do
    translated_position = {x_t, y_t} = {x - x_origin, y - y_origin}
    if x_t >= 0 && x_t < width && y_t >= 0 && y_t < height do
      send_update PixelParty.GridCellComponent, id: translated_position, color: color
    end
    {:noreply, socket}
  end

  @impl true
  def handle_info(
        %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
        socket
      ) do
    presence =
      Map.merge(socket.assigns.presence, joins)
      |> Map.drop(Map.keys(leaves))

    {:noreply, assign(socket, :presence, presence)}
  end

  defp move(%{assigns: %{width: width, height: height, origin: {x, y}}} = socket, direction) do
    {x_origin, y_origin} =
      origin =
      case direction do
        :right -> {x + 1, y}
        :left -> {x - 1, y}
        :up -> {x, y - 1}
        :down -> {x, y + 1}
      end

    translated_grid =
      PixelParty.Grid.viewport(origin, width, height)
      |> Enum.map(fn {{x, y}, color} ->
        {{x - x_origin, y - y_origin}, color}
      end)
      |> Map.new()

    socket
    |> assign(:origin, origin)
    |> assign(:render_grid, translated_grid)
  end
end
