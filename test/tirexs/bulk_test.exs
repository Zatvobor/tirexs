Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Tirexs.BulkTest do

  use ExUnit.Case

  import Tirexs.Bulk

  test :get_id_from_document do
    document = [id: "id", title: "Hello"]
    assert get_id_from_document(document) == "id"

    document = [{:id, "id"}, {:title, "Hello"}]
    assert get_id_from_document(document) == "id"

    document = [_id: "_id", title: "Hello"]
    assert get_id_from_document(document) == "_id"

    document = [{:_id, "_id"}, {:title, "Hello"}]
    assert get_id_from_document(document) == "_id"
  end

  test :convert_document_to_json do
    document = [id: "id", title: "Hello"]

    assert convert_document_to_json(document) == "{\"id\":\"id\",\"title\":\"Hello\"}"
  end

  test :get_type_from_document do
    document = [id: "id", title: "Hello", type: "my_type"]

    assert get_type_from_document(document) == "my_type"
  end
end
