defmodule PixelPartyWeb.PageLiveTest do
  use PixelPartyWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "<h1>Pixel Party</h1>"
    assert render(page_live) =~ "<h1>Pixel Party</h1>"
  end

  test "clicking around", %{conn: conn} do
    {:ok, live, html} = live(conn, "/")

    assert html =~ "<div id=\"0-0\" class=\"grid-cell white\""
    assert live
    |> element("#0-0")
    |> render_click() =~ "<div id=\"0-0\" class=\"grid-cell black\""


    assert live
    |> element("#0-0")
    |> render_click() =~ "<div id=\"0-0\" class=\"grid-cell gray\""

    assert live
    |> element("#0-0")
    |> render_click() =~ "<div id=\"0-0\" class=\"grid-cell red\""

    # keeep our color as we move around
    assert html =~ "<div id=\"0-1\" class=\"grid-cell white\""

    assert live
    |> element("#0-1")
    |> render_click() =~ "<div id=\"0-1\" class=\"grid-cell red\""

    assert live
    |> element("#0-2")
    |> render_click() =~ "<div id=\"0-2\" class=\"grid-cell red\""
  end
end
