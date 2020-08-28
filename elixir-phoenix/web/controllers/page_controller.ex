defmodule BotoGP.PageController do
  use BotoGP.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
