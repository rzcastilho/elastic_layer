defmodule Middleware do
  use Plug.Router
  
  plug :match
  plug :dispatch
  plug Plug.Logger, log: :debug
  plug Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["text/*"],
    json_decoder: Jason
  plug Middleware.Plugs.AssignSearchReqStruct
  plug Middleware.Plugs.ExtractCustomParams
  plug Middleware.Plugs.BuildRequest
  plug Middleware.Plugs.GetCache
  plug Middleware.Plugs.ElasticDispatcher
  
  get "/:target/_search", do: conn
  post "/:target/_search", do: conn
  
  match _ do
    conn
    |> send_resp(404, "oops")
    |> halt()
  end

end
