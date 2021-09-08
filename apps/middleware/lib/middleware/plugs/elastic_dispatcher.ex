defmodule Middleware.Plugs.ElasticDispatcher do
  import Plug.Conn
  
  require Logger
  
  alias Middleware.{ElasticAPI, SearchRequest, MultilevelCache}
  
  def init([]), do: []
  
  def call(%Plug.Conn{method: method, body_params: body_params, assigns: %{search_request: %SearchRequest{request_id: request_id, url: url, ttl: ttl}}} = conn, _opts) do
    case ElasticAPI.request!(method, url, Jason.encode!(body_params)) do
      %HTTPoison.Response{body: body, headers: headers, status_code: status_code} ->
        Logger.info(fn -> "No Cached Response" end)
        if status_code == 200, do: MultilevelCache.put(request_id, {headers, body}, ttl: ttl)
        conn
        |> prepend_resp_headers(headers)
        |> send_resp(status_code, body |> Jason.encode!())
      _ ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(500, ":-(")
    end
  end
  
end
