defmodule PixelParty.Grid do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def viewport({x_origin, y_origin}, width, height) do
    Agent.get(__MODULE__, fn grid ->
      for y <- y_origin..height-1, x <- x_origin..width-1, into: %{}, do: {{x,y}, Map.get(grid, {x,y}, :white)}
    end)
  end

  def change_color(pos)  do
    Agent.get_and_update(__MODULE__, fn grid ->
      new_color = next_color(Map.get(grid, pos, :white))
      {new_color, Map.put(grid, pos, new_color)}
    end)
  end

  def change_color(pos, color) do
    Agent.get_and_update(__MODULE__, fn grid ->
      {color, Map.put(grid, pos, color)}
    end)
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
