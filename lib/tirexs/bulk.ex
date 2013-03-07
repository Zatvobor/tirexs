defmodule Tirexs.Bulk do

  import Tirexs.Bulk.Helpers
  import Tirexs.Helpers

  defmacro store(options, settings, [do: block]) do
    documents = get_clear_block(block)
    options = options
    quote do
      [documents, options, settings] = [unquote(documents), unquote(options), unquote(settings)]
      bulk(documents, options, settings)
    end
  end

  def create(opts) do
    [create: opts]
  end

  def delete(opts) do
    [delete: opts]
  end

  def index(opts) do
    [index: opts]
  end

  def bulk(documents, options, settings) do
    index = options[:index]
    options = Dict.delete(options, :index)
    payload = Enum.map documents, fn(document) ->
      action = key(document)
      document = document[action]
      type = get_type_from_document(document) || "document"
      id   = get_id_from_document(document)
      header = [_index: index, _type: type, _id: id ]
      [document, meta] = meta([:_version, :_routing, :_percolate, :_parent, :_timestamp, :_ttl], document, header)
      header = Dict.put([], action, meta)

      output = []
      output =  output ++ [JSON.encode(header)]
      unless action == :delete do
        output =  output ++ [convert_document_to_json(document)]
      end
      Enum.join(output, "\n")
    end
    payload = payload ++ [""]
    payload = Enum.join(payload, "\n")
    Tirexs.ElasticSearch.post("_bulk#{to_param(options, "")}", payload, settings)
  end

  def meta([], document, acc) do
    [document, acc]
  end

  def meta([h|t], document, acc) do
    unless document[h] == nil do
      acc = Dict.put(acc, h, document[h])
      document = Dict.delete(document, h)
    end
    meta(t, document, acc)
  end



end