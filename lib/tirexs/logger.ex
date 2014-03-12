defmodule Tirexs.Logger do
  @moduledoc false

  def to_curl(data) do
    case JSEX.is_json?(data) do
      true  -> log(data)
      false -> log(JSEX.encode!(data))
    end
  end

  defp log(json) do
    :error_logger.info_msg(JSEX.prettify!(json))
  end

end