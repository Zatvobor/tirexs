ExUnit.start

defmodule ParserResponse do
  def get_body_json(body) do
    case body do
      [:ok, _, body] -> JSON.decode(to_binary(body))
      [:error, status,  message] -> message
    end
  end
end

