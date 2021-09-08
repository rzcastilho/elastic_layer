defmodule Middleware.Util do
  
  def extract_search_structure(map) when is_map(map) do
    for {key, val} <- map, into: %{}, do: {key_to_atom(key), extract_search_structure(val)}
  end
  
  def extract_search_structure(list) when is_list(list) do
    list
    |> Enum.map(&extract_search_structure/1)
  end
  
  def extract_search_structure(_value), do: nil
  
  defp key_to_atom(key) when is_atom(key), do: key
  defp key_to_atom(key) when is_binary(key), do: String.to_atom(key)
  
end
