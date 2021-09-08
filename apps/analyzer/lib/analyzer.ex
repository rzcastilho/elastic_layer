defmodule Analyzer do
  use GenServer
  alias Phoenix.PubSub
  
  def start_link() do
    GenServer.start_link(__MODULE__, 0)
  end
  
  def init(count) do
    PubSub.subscribe(:elastic_layer, "searches")
    {:ok, count}
  end
  
  def handle_info({:search, _} = event, state) do
    IO.inspect(event)
    {:noreply, state + 1}
  end
  
end
