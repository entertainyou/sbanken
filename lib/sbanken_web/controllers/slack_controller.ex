defmodule SbankenWeb.SlackController do
  use SbankenWeb, :controller

  alias SbankenMonitor.TokenedClient
  alias Sbanken.Slack

  def get_transactions(account_id) do
    with {:ok, res} <- TokenedClient.get_transactions(account_id),
      200 <- res.status,
      {:ok, transactions} <- Map.fetch(res.body, "items") do

      result = transactions
      |> Enum.take(20)
      |> Enum.map(fn %{"amount" => amount, "text" => text, "accountingDate" => accounting_date} ->
        "#{text} #{amount} @ #{accounting_date}"
      end)
      |> Enum.join("\n")
      {:ok, result} |> IO.inspect()
    end
  end
  
  def check(response_url) do
    with {:ok, res} <- TokenedClient.get_accounts(),
      200 <- res.status,
      {:ok, items} <- Map.fetch(res.body, "items") do
      text = items
      |> Enum.map(fn %{"name" => name, "available" => available, "accountId" => account_id} ->
        {:ok, result} = get_transactions(account_id)
	"""
        #{account_id}(#{name}): #{available}

        #{result}
	"""
      end)
      |> Enum.join("\n\n")
      Slack.send_response(response_url, %{text: text}) |> IO.inspect()
    end
  end
  
  def sbanken(conn, %{"text" => "list", "response_url" => response_url}) do
    Task.start(fn -> check(response_url) end)
    conn |> text("")
  end

  def sbanken(conn, _params) do
    conn |> text("Not supported")
  end
end
