defmodule Middleware.Plugs.ExtractCustomParams do
  import Plug.Conn
  
  alias Middleware.SearchRequest
  
  def init([]), do: []
  
  def call(%Plug.Conn{query_params: %{}} = conn, _opts) do
    conn
    |> check_nocache
    |> check_ttl
  end
  
  def check_nocache(%Plug.Conn{assigns: %{search_request: search_request}, query_params: %{"nocache" => _} = query_params} = conn) do
    with query_params <- Map.delete(query_params, "nocache") do
      %Plug.Conn{conn | query_params: query_params, query_string: Plug.Conn.Query.encode(query_params)}
      |> assign(:search_request, %SearchRequest{search_request | ignore_cache?: true})
    end
  end
  
  def check_nocache(conn), do: conn
  
  def check_ttl(%Plug.Conn{assigns: %{search_request: search_request}, query_params: %{"ttl" => ttl} = query_params} = conn) do
    with query_params <- Map.delete(query_params, "ttl"),
         {ttl, ""} <- Integer.parse(ttl) do
      %Plug.Conn{conn | query_params: query_params, query_string: Plug.Conn.Query.encode(query_params)}
      |> assign(:search_request, %SearchRequest{search_request | ttl: ttl})
    else
      _ ->
        conn
        |> send_resp(404, "oops")
        |> halt()
    end
  end
  
  def check_ttl(conn), do: conn
  
end
