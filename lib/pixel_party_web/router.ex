defmodule PixelPartyWeb.Router do
  use PixelPartyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PixelPartyWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PixelPartyWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PixelPartyWeb do
  #   pipe_through :api
  # end
end
