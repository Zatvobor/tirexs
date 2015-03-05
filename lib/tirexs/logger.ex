defmodule Tirexs.Logger do
  @moduledoc false

  def to_curl(data) do
    case JSX.is_json?(data) do
      true  -> log(data)
      false -> log(JSX.encode!(data))
    end
  end

  defp log(json) do
    :error_logger.info_msg(JSX.prettify!(json))
  end

end
