defmodule Tirexs.Bulk.Helpers do
  def get_id_from_document(document) do
    document[:id] || document["id"] || document[:_id] || document["_id"]
  end

  def convert_document_to_json(document) do
    JSON.encode(document)
  end

  def get_type_from_document(document) do
    document[:_type] || document["_type"] || document[:type] || document["type"] || "document"
  end
end