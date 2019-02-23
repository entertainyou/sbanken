defmodule SbankenWeb.Router do
  use SbankenWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SbankenWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/slack/sbanken", SlackController, :sbanken
  end

  # Other scopes may use custom stacks.
  # scope "/api", SbankenWeb do
  #   pipe_through :api
  # end
end
