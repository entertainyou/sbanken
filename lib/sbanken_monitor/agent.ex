defmodule SbankenMonitor.Agent do
  @moduledoc false
  defmacro __using__(opts) do
    interval = Keyword.get(opts, :interval)
    immediate = Keyword.get(opts, :immediate, false)

    quote do
      use GenServer
      require Logger

      def start_link(args) do
        Logger.debug(fn -> "#{__MODULE__} start_link args: #{inspect(args)}" end)
        GenServer.start_link(__MODULE__, args, name: __MODULE__)
      end

      def init(_args) do
        Logger.debug(fn -> "#{__MODULE__} init" end)
        state = %__MODULE__.State{}
        schedule()

        if unquote(immediate) do
          {:ok, do_work(state)}
        else
          {:ok, state}
        end
      end

      defp schedule() do
        Process.send_after(self(), :work, unquote(interval))
      end

      def handle_info(:work, state) do
        schedule()
        new_state = do_work(state)
        Logger.debug(fn -> "#{__MODULE__} handle_info" end)
        {:noreply, new_state}
      end
    end
  end
end
