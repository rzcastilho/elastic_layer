defmodule Middleware.SearchRequest do
  defstruct [
    :url,
    :request_id,
    :search_id,
    ttl: 300_000,
    cacheable?: true,
    ignore_cache?: false
  ] 
end
