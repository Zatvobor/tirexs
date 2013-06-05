defmodule Tirexs.Logger do
  @moduledoc false

	def to_curl(data) do
		case JSEX.is_json?(data) do
			true  -> log(data)
			false -> log(JSEX.encode!(data))
		end
	end

	defp log(json) do
		IO.puts JSEX.prettify!(json)
	end

end