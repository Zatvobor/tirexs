defmodule Tirexs.Bulk do
  @moduledoc false

  import Tirexs.DSL.Logic

  @doc false
  defmacro store(options, settings, [do: block]) do
    documents = extract_block(block)
    quote do
      [documents, options, settings] = [unquote(documents), unquote(options), unquote(settings)]
      # Wrap documents if not in a list (note that each item is a keyword list)
      unless hd(documents) |> is_list, do: documents = [documents]
      bulk(documents, options, settings)
    end
  end

  @doc false
  def create(doc) do
    doc = match(doc)
    {doc, action_header} = create_action_and_header(:create, doc)
    [action_header, doc]
  end

  @doc false
  def delete(doc) do
    doc = match(doc)
    {doc, action_header} = create_action_and_header(:delete, doc)
    [action_header]
  end

  @doc false
  def index(doc) do
    doc = match(doc)
    {doc, action_header} = create_action_and_header(:index, doc)
    [action_header, doc]
  end

  @doc """
    Updates document with options
    Available options are:
    - upsert: true/false (update or fallback to create if doc with id does not exist)
    - retry_on_conflict: integer (number of times to retry if conflict exists)
  """
  def update(doc, opts \\ []) do
    doc = match(doc)
    {doc, action_header} = create_action_and_header(:update, doc)
    if Keyword.has_key?(opts, :retry_on_conflict) do
      action_header = Keyword.put(action_header, :_retry_on_conflict, Keyword.get(opts, :retry_on_conflict))
    end
    doc_info = [doc: doc]
    if Keyword.get(opts, :upsert), do: doc_info = Keyword.put(doc_info, :doc_as_upsert, true)
    [action_header, doc_info]
  end

  # Returns a tuple of doc and action/header tuple
  # The doc has keys stripped out that are in header
  defp create_action_and_header(action, doc) do
    {doc, header} = extract_keys([:_version, :_routing, :_percolate, :_parent, :_timestamp, :_ttl], doc, [])
    header =
      Keyword.put(header, :_id, get_id_from_document(doc))
      |> Keyword.put(:_type, get_type_from_document(doc))
    {doc, {action, header}}
  end

  @doc false
  def bulk(documents, options, settings) do
    index = options[:index]
    options = Dict.delete(options, :index)

    retry_on_conflict = options[:retry_on_conflict]
    options = Dict.delete(options, :retry_on_conflict)

    id = options[:id]
    options = Dict.delete(options, :id)

    payload = Enum.map documents, fn(infos) ->
      {action, header} = hd(infos)

      header = Keyword.put(header, :_index, index)
      if retry_on_conflict != nil and !Keyword.has_key?(header, :_retry_on_conflict) do
        header = Keyword.put(header, :_retry_on_conflict, retry_on_conflict)
      end

      header = Map.put(%{}, action, header)

      output = []
      output =  output ++ [JSX.encode!(header)]

      doc_info = infos |> Enum.at(1)
      if doc_info do
        output =  output ++ [convert_document_to_json(doc_info)]
      end
      Enum.join(output, "\n")
    end
    payload = payload ++ [""]
    payload = Enum.join(payload, "\n")
    Tirexs.ElasticSearch.post("_bulk" <> to_param(options, ""), payload, settings)
  end

  @doc false
  def extract_keys([], document, acc), do: {document, acc}
  def extract_keys([h|t], document, acc) do
    unless document[h] == nil do
      acc = Keyword.put(acc, h, document[h])
      document = Keyword.delete(document, h)
    end
    extract_keys(t, document, acc)
  end

  @doc false
  def get_id_from_document(document) do
    document[:id] || document[:_id]
  end

  @doc false
  def convert_document_to_json(document) do
    JSX.encode!(document)
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
