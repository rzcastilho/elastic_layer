defmodule Middleware.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
 
  @impl true
  def start(_type, _args) do
    children = [
      {
        Cluster.Supervisor,
        [
          Application.get_env(:libcluster, :topologies),
          [name: Middleware.ClusterSupervisor]
        ]
      },
      {Phoenix.PubSub, name: :search_request},
      {Plug.Cowboy, scheme: :http, plug: Middleware, options: [port: String.to_integer(System.get_env("PORT") || "4000")]},
      Middleware.MultilevelCache
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Middleware.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
