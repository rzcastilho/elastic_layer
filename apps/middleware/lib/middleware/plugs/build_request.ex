defmodule Middleware.Plugs.BuildRequest do
  import Plug.Conn
  
  alias Middleware.{SearchRequest, Util}
  alias Phoenix.PubSub
  
  def init([]), do: []
  
  def call(%Plug.Conn{assigns: %{search_request: search_request}, method: method, request_path: request_path, query_string: query_string, body_params: body_params} = conn, _opts) when map_size(body_params) == 0  do
    with url <- "#{URI.merge("http://localhost:9200", append_query_string(request_path, query_string)) |> to_string()}",
         request_sha <- :crypto.hash(:sha, "#{method} #{url}"),
         request_id <- Base.encode64(request_sha),
         search_request <- %SearchRequest{search_request | url: url, request_id: request_id} do
      PubSub.broadcast(:search_request, "searches", {:search, search_request})
      assign(conn, :search_request, search_request)
    end
  end
  
  def call(%Plug.Conn{assigns: %{search_request: search_request}, method: method, request_path: request_path, query_string: query_string, params: %{"target" => target}, body_params: body_params} = conn, _opts) do
    with url <- "#{URI.merge("http://localhost:9200", append_query_string(request_path, query_string)) |> to_string()}",
         body <- Jason.encode!(body_params),
         search_structure <- Util.extract_search_structure(body_params),
         search_sha <- :crypto.hash(:sha, "#{target}\n#{Jason.encode!(search_structure)}"),
         search_id <- Base.encode64(search_sha),
         request_sha <- :crypto.hash(:sha, "#{method} #{url}\n#{body}"),
         request_id <- Base.encode64(request_sha),
         search_request <- %SearchRequest{search_request | url: url, request_id: request_id, search_id: search_id} do
      PubSub.broadcast(:search_request, "searches", {:search, search_request})
      assign(conn, :search_request, search_request)
    end
  end
  
  defp append_query_string(request_path, ""), do: request_path
  defp append_query_string(request_path, nil), do: request_path
  defp append_query_string(request_path, query_string), do: "#{request_path}?#{query_string}"
  
end
