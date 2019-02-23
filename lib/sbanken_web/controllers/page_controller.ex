defmodule SbankenWeb.PageController do
  use SbankenWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
