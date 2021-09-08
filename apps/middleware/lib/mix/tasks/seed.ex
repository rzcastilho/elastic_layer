defmodule Mix.Tasks.Seed do
  @moduledoc "Seed local data for development"
  @shortdoc "Seed local data for development"
  
  @words File.read!("names.txt") |> String.split("\r\n") |> Enum.shuffle() |> Enum.take(5_000)
  @words_count Enum.count(@words)
  
  use Mix.Task
  alias Elastix.{Bulk, HTTP, Index}
  
  @impl Mix.Task
  @spec run(any) :: :ok | {any, non_neg_integer}
  def run(args) do
    Mix.Task.run("app.start", [])
    seed(Mix.env(), args)
  end
  
  defp seed(:dev, ["elasticsearch", index_name, alias_name, docs_count | _]) do
    do_seed(index_name, alias_name, String.to_integer(docs_count))
  end
  
  defp seed(:dev, ["elasticsearch", index_name, alias_name | _]) do
    do_seed(index_name, alias_name)
  end
  
  defp seed(:dev, ["elasticsearch", index_name | _]) do
    do_seed(index_name)
  end
  
  defp setup_container() do
    IO.puts("Checking running elasticsearch container...")
    case System.cmd("docker", ["ps", "--filter", "name=elasticsearc", "-a", "-q"]) do
      {<<id :: bytes-size(12) >> <> "\n", 0} ->
        IO.puts("Killing container #{id}...")
        System.cmd("docker", ["rm", id, "--force"])
      _ ->
        IO.puts("There's no running container now!")
    end
    IO.puts("Initializing new Elasticsearch container...")
    System.cmd("docker", ["run", "-d", "--name", "elasticsearch", "-p", "9200:9200", "-p", "9300:9300", "-e", "\"discovery.type=single-node\"", "elasticsearch:6.8.1"])
  end
  
  defp wait_es_up_and_running() do
    case HTTP.get("#{Application.get_env(:elastix, :url)}_cluster/health") do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        IO.puts("Container is up and running...")
        :ok
      _ ->
        IO.puts("Container isn't up and running, checking again in 5 seconds...")
        Process.sleep(5000)
        wait_es_up_and_running()
    end
  end
  
  defp create_index(index_name, alias_name) do
    IO.puts("Creating index #{index_name} at #{Application.get_env(:elastix, :url)}...")
    Index.create(Application.get_env(:elastix, :url), index_name, definition(alias_name))
  end
  
  defp definition(alias_name) do
    %{
      "aliases" => aliases(alias_name),
      "mappings" => %{
        "_doc" => %{
          "dynamic" => "false",
          "properties" => %{
            "description" => %{
              "fields" => %{
                "keyword" => %{"ignore_above" => 256, "type" => "keyword"}
              },
              "type" => "text"
            },
            "location" => %{"type" => "geo_point"},
            "name" => %{
              "fields" => %{
                "keyword" => %{"ignore_above" => 256, "type" => "keyword"}
              },
              "type" => "text"
            },
            "position" => %{"type" => "integer"}
          }
        }
      },
      "settings" => %{
        "index" => %{"number_of_replicas" => "0", "number_of_shards" => "1"}
      }
    }
  end
  
  def aliases(nil), do: %{}
  def aliases(alias_name), do: %{alias_name => %{"is_write_index" => true}}
  
  def index_random(index_name, type_name, docs_count, bulk \\ 1_000) do
    IO.puts("Generating #{docs_count} of random #{type_name} types at index #{index_name}...")
    1..docs_count
    |> Stream.map(fn
      th ->
        [
          %{
            "index" => %{
              "_index" => index_name,
              "_type" => type_name
            }
          },
          %{
            "name" => text_gen(2, "-"),
            "description" => text_gen(25),
            "position" => th,
            "location" => %{
              "lat" => (-89..89 |> Enum.take_random(1) |> hd) + :rand.uniform,
              "lon" => (-179..179 |> Enum.take_random(1) |> hd) + :rand.uniform
            }
          }
        ]
    end)
    |> Stream.chunk_every(bulk)
    |> Enum.map(
      fn data ->
        IO.puts("Sending #{bulk} documents...")
        Bulk.post("#{Application.get_env(:elastix, :url)}", List.flatten(data))
      end
    )
  end
  
  def text_gen(num_words, separator \\ " ") do
    @words
    |> Enum.slice(:rand.uniform(@words_count) - 1, num_words)
    |> Enum.join(separator)
  end
  
  def do_seed(index_name, alias_name \\ nil, docs_count \\ 1_000_000) do
    IO.puts("Starting seed process...")
    setup_container()
    wait_es_up_and_running()
    create_index(index_name, alias_name)
    index_random(index_name, "_doc", docs_count)
    IO.puts("Seed process finished!")
  end
  
end
