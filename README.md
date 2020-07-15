# Creating a new app

1. Get elixir installed (if using Nix, just run `nix-shell` in this directory)
2. `mix archive.install hex phx_new 1.5.3`
3. `mix phx.new . --app pixel_party --module PixelParty --live --no-ecto --no-gettext --no-dashboard`
4. Bump live view in `mix.exs` -> `{:phoenix_live_view, "~> 0.14.1"},` and run `mix deps.get`

(this is available in the git tag `initial`)

# Run the server

`iex -S mix phx.server`