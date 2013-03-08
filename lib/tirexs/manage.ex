defmodule Tirexs.Manage do
  import Tirexs.Manage.Aliases

  def count(options) do
    Tirexsl.ElasticSearch.post("_count", options)
  end
end