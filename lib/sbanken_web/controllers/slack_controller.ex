defmodule SbankenWeb.SlackController do
  use SbankenWeb, :controller

  def sbanken(conn, params) do
    # render(conn, "index.html")
    params |> IO.inspect
    
    conn |> text("Haha")
  end
end
