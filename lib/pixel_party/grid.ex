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

  def set(pos, color)  do
    Agent.update(__MODULE__, fn grid ->
      Map.put(grid, pos, color)
    end)
  end
end
