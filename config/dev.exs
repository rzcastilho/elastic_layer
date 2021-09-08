import Config

config :elastix,
  url: "http://localhost:9200/",
  json_codec: Jason,
  httpoison_options: [ssl: [{:versions, [:tlsv1, :"tlsv1.1", :"tlsv1.2"]}], recv_timeout: 120_000]

config :middleware,
  http_client: Elastix.HTTP

config :libcluster,
  topologies: [
    elastic_layer: [
      strategy: Elixir.Cluster.Strategy.LocalEpmd]]
