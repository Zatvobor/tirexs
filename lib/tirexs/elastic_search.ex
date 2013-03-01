defmodule Tirexs.ElasticSearch do

  @doc """
  This module provides a simple convenience for connection options such as `port`, `uri`, `user`, `pass`
  """
  defrecord Config,  [port: 9200, uri: "127.0.0.1", user: nil, pass: nil]

end