defmodule Sbanken.Slack do
  @moduledoc false

  use Tesla
  plug(Tesla.Middleware.JSON)

  def send_response(response_url, payload) do
    post(response_url, payload)
  end
end
