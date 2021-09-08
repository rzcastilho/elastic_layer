defmodule Payload do
  
  def request(keyword) do
    %{
      "query" => %{
        "bool" => %{"must" => [%{"term" => %{"name.keyword" => keyword}}]}
      }
    }
  end
  
  def response(keyword) do
    %{
      "_shards" => %{"failed" => 0, "skipped" => 0, "successful" => 1, "total" => 1},
      "hits" => %{
        "hits" => [
          %{
            "_id" => "6GAReXsB218scVXM_ijG",
            "_index" => "oferta-000001",
            "_score" => 8.424159,
            "_source" => %{
              "description" => "gynaecocrat maguari marchesi disseizure chironomic almner kochliarion purslanes ragsorter nookier playfere beetroots diamant cathodograph gramarye nominalism anils indusial trochalopodous commerciality biocentric unstriated culvertage gynostegigia sparklingly",
              "location" => %{
                "lat" => -43.05512068440648,
                "lon" => 100.58381894878752
              },
              "name" => keyword,
              "position" => 18488
            }, 
            "_type" => "_doc"
          },
          %{
            "_id" => "OmAReXsB218scVXM_irG",
            "_index" => "oferta-000001",
            "_score" => 8.424159,
            "_source" => %{
              "description" => "noumea phantasmological cleaver acromelalgia suggestivity forthwith dihexahedron pangane nonciteable chromosomal decerebration crestfallenly danakil baldfaced pulian chromatoptometer cardionecrosis overbodice shivarees selaginellaceous costeaning tubulures brobdingnagian aestivates superingeniousness",
              "location" => %{
                "lat" => 22.519811851184336,
                "lon" => 170.26893100317952
              },
              "name" => keyword,
              "position" => 18826
            },
            "_type" => "_doc"
          }
        ],
        "max_score" => 8.424159,
        "total" => 219
      },
      "timed_out" => false,
      "took" => 11
    }
  end
  
end
