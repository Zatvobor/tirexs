Code.require_file "../test_helper.exs", __FILE__

defmodule ElasticSearchSettingsTest do
  use ExUnit.Case
  use Tirexs.ElasticSettings

  test :replace_default_config do
    settings = elastic_settings.new([port: 500, uri: "127.0.0.1"])
    assert settings.port == 500
    assert settings.uri == "127.0.0.1"
  end
end