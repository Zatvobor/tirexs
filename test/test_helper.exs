ExUnit.start

defmodule TestHelpers do
  import :timer, only: [ sleep: 1 ]

  def create_index(name, settings), do: Tirexs.ElasticSearch.put(name, settings)
  def remove_index(name, settings), do: Tirexs.ElasticSearch.delete(name, settings)

  def repeat(func) do
    repeat_receiving_until(503, 200, 10, func)
  end

  defp repeat_receiving_until(_status, _result_status, 1, func)  do
    func.()
  end

  defp repeat_receiving_until(status, result_status, retries, func)  do
    case func.() do
      {str_res, ^result_status, body} -> {str_res, result_status, body}
      {_, ^status, _} ->
        sleep 100
        repeat_receiving_until(status, result_status, retries - 1, func)
      result -> result
    end
  end

end
