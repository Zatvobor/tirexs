defmodule Tirexs.Bulk do
  @moduledoc false

  import Tirexs.DSL.Logic

  defmacro store(options, settings, [do: block]) do
    documents = extract_block(block)
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

	def update(opts) do
		[update: opts]
	end

  def bulk(documents, options, settings) do
    index = options[:index]
		retry_on_conflict = options[:retry_on_conflict]
		options = Dict.delete(options, :retry_on_conflict)
    options = Dict.delete(options, :index)
		id = options[:id]
		options = Dict.delete(options, :id)
    payload = Enum.map documents, fn(document) ->
      document = match(document)
			action = key(document)
      document = document[action]
      type = get_type_from_document(document)
      unless id do
				id   = get_id_from_document(document)
			end

			header = [_index: index, _type: type, _id: id ]
			if retry_on_conflict do
				header = Dict.put(header, :retry_on_conflict, retry_on_conflict)
			end

      [document, meta] = meta([:_version, :_routing, :_percolate, :_parent, :_timestamp, :_ttl], document, header)
      header = Dict.put([], action, meta)

      output = []
      output =  output ++ [JSEX.encode!(header)]
      unless action == :delete do
        output =  output ++ [convert_document_to_json(document)]
      end
      Enum.join(output, "\n")
    end
    payload = payload ++ [""]
    payload = Enum.join(payload, "\n")
    Tirexs.ElasticSearch.post("_bulk" <> to_param(options, ""), payload, settings)
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

  def get_id_from_document(document) do
    document[:id] || document[:_id]
  end

  def convert_document_to_json(document) do
    JSEX.encode!(document)
  end

  def get_type_from_document(document) do
    document[:_type] || document[:type] || "document"
  end

	def match(document) do
		case is_list(document) do
			true  -> document
			false ->
				{key, properties} = document
				Dict.put([], key, properties)
		end
	end

end
