defmodule Tirexs.Bulk do
  @moduledoc false

  import Tirexs.DSL.Logic


  @doc false
  defmacro store(options, uri, [do: block]) do
    documents = extract_block(block)
    quote do
      [documents, options, uri] = [unquote(documents), unquote(options), unquote(uri)]
      bulk(documents, options, uri)
    end
  end

  @doc false
  defmacro store(options, [do: block]) do
    quote do
      store(unquote(options), Tirexs.get_uri_env(), [do: unquote(block)])
    end
  end


  @doc false
  def create(opts), do: [create: opts]

  @doc false
  def delete(opts), do: [delete: opts]

  @doc false
  def index(opts),  do: [index: opts]

  @doc false
  def update(opts), do: [update: opts]

  @doc false
  def bulk(documents, options, settings) do
    index = options[:index]
    options = Dict.delete(options, :index)

    retry_on_conflict = options[:retry_on_conflict]
    options = Dict.delete(options, :retry_on_conflict)

    id = options[:id]
    options = Dict.delete(options, :id)

    payload = Enum.map documents, fn(document) ->

      document = match(document)
      action = key(document)
      document = document[action]
      type = get_type_from_document(document)

      unless id do
        id = get_id_from_document(document)
      end

      header = [_index: index, _type: type, _id: id ]
      if retry_on_conflict do
        header = Dict.put(header, :_retry_on_conflict, retry_on_conflict)
      end

      [document, meta] = meta([:_version, :_routing, :_percolate, :_parent, :_timestamp, :_ttl], document, header)
      header = Dict.put([], action, meta)

      output = []
      output =  output ++ [Tirexs.HTTP.encode(header)]
      unless action == :delete do
        output =  output ++ [convert_document_to_json(document)]
      end
      Enum.join(output, "\n")
    end
    payload = payload ++ [""]
    payload = Enum.join(payload, "\n")
    Tirexs.ElasticSearch.post("_bulk" <> to_param(options, ""), payload, settings)
  end

  @doc false
  def meta([], document, acc) do
    [document, acc]
  end

  @doc false
  def meta([h|t], document, acc) do
    unless document[h] == nil do
      acc = Dict.put(acc, h, document[h])
      document = Dict.delete(document, h)
    end
    meta(t, document, acc)
  end

  @doc false
  def get_id_from_document(document) do
    document[:id] || document[:_id]
  end

  @doc false
  def convert_document_to_json(document) do
    Tirexs.HTTP.encode(document)
  end

  @doc false
  def get_type_from_document(document) do
    document[:_type] || document[:type] || "document"
  end

  @doc false
  def match(document) do
    case is_list(document) do
      true  -> document
      false ->
        {key, properties} = document
        Dict.put([], key, properties)
    end
  end
end
