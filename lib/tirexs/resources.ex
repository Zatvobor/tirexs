defmodule Tirexs.Resources do
  @moduledoc false

  import Tirexs.HTTP


  @doc false
  def exists?(path, uri) when is_binary(path) and is_map(uri) do
    ok?(head(path, uri))
  end
  def exists?(url_or_path_or_uri) do
    ok?(head(url_or_path_or_uri))
  end
  def exists!(path, uri) when is_binary(path) and is_map(uri) do
    head!(path, uri)
  end
  def exists!(url_or_path_or_uri) do
    head!(url_or_path_or_uri)
  end

  @doc false
  def _refresh(resource, uri) when is_binary(resource) do
    post(to_string(resource) <> "/_refresh", uri)
  end
  def _refresh(resources, uri) when is_list(resources) do
    _refresh(Enum.join(resources, ","), uri)
  end
  def _refresh(resource) when is_binary(resource) do
    post(to_string(resource) <> "/_refresh")
  end
  def _refresh(resources) when is_list(resources) do
    _refresh(Enum.join(resources, ","))
  end
  def _refresh!(resource, uri) when is_binary(resource) do
    ok!(_refresh(resource, uri))
  end
  def _refresh!(resources, uri) when is_list(resources) do
    ok!(_refresh(resources, uri))
  end
  def _refresh!(resource) when is_binary(resource) do
    ok!(_refresh(resource))
  end
  def _refresh!(resources) when is_list(resources) do
    ok!(_refresh(resources))
  end
end
