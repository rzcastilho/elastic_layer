defmodule Middleware.Plugs.GetCache do
  import Plug.Conn
  
  require Logger
  
  alias Middleware.{SearchRequest, MultilevelCache}
  
  def init([]), do: []
  
  def call(%Plug.Conn{assigns: %{search_request: %SearchRequest{ignore_cache?: true}}} = conn, _opts), do: conn
  
  def call(%Plug.Conn{assigns: %{search_request: %SearchRequest{request_id: request_id}}} = conn, _opts) do
    case MultilevelCache.get(request_id) do
      nil ->
        conn
      {headers, body} ->
        Logger.info(fn -> "Cached response" end)
        conn
        |> prepend_resp_headers(headers)
        |> send_resp(200, Jason.encode!(body))
        |> halt()
    end
  end
  
end
