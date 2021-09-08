defmodule Middleware.Plugs.AssignSearchReqStruct do
  import Plug.Conn
  
  alias Middleware.SearchRequest
  
  def init([]), do: []
  
  def call(conn, _opts), do: assign(conn, :search_request, %SearchRequest{})
  
end
