defmodule Playground do
  use GenServer

  def child_spec(_) do
    %{
      id: Playground,
      start: {Playground, :start_link, []},
      restart: :transient
    }
  end

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: Playground)
  end

  def crash() do
    GenServer.cast(Playground, :crash)
  end

  def stop() do
    GenServer.cast(Playground, :stop)
  end

  def alive?() do
    GenServer.call(Playground, :alive?)
  end

  # Server callbacks
  def init(:ok) do
    {:ok, 0}
  end

  def handle_cast(:crash, state) do
    1 / 0
    {:no_reply, state}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_call(:alive?, _from, state) do
    state = state + 1
    {:reply, state, state}
  end
end

defmodule Playground.Supervisor do
  use Supervisor
  require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      Playground
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def handle_info(message, state) do
    message |> inspect |> Logger.debug()
    state |> inspect |> Logger.debug()
  end
end
