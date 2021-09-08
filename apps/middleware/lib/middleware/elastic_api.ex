defmodule Middleware.ElasticAPI do
  
  def request!(method, url, body \\ "", headers \\ [], options \\ []) do
    http_client().request!(method, url, body, headers, options)
  end
  
  defp http_client() do
    Application.get_env(:middleware, :http_client)
  end
  
end
