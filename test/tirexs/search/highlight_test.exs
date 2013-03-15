Code.require_file "../../../test_helper.exs", __FILE__
defmodule Tirexs.Search.HighlightTest do
  use ExUnit.Case
  import Tirexs.Search

  test :highlight do
    highlight = highlight do
      [ number_of_fragments: 3,
        fragment_size: 150,
        tag_schema: "styled",
        fields: [
            _all: [pre_tags: ["<em>"], post_tags: ["</em>"]],
            "bio.title": [number_of_fragments: 0],
            "bio.author": [number_of_fragments: 0],
            "bio.content": [number_of_fragments: 5, order: "score" ]
          ]
      ]
    end

    assert highlight ==  [highlight: [number_of_fragments: 3, fragment_size: 150, tag_schema: "styled", fields: [_all: [pre_tags: ["<em>"], post_tags: ["</em>"]], "bio.title": [number_of_fragments: 0], "bio.author": [number_of_fragments: 0], "bio.content": [number_of_fragments: 5, order: "score"]]]]
  end
end