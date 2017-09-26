defmodule Tirexs.HTTP.Shared do
  @doc false
  def request(method, request, http_options, options) do
    { :ok, _ } = :application.ensure_all_started(:tirexs)
    Tirexs.Logger.log_command(method, request)
    :httpc.request(method, request, http_options, options)
  end

  @doc false
  def response(req) do
    case req do
      {:ok, { {_, status, _}, _, body}} ->
        if round(status / 100) == 4 || round(status / 100) == 5 do
          {:error, status, body}
        else
          {:ok, status, body}
        end
      _ -> :error
    end
  end

  @doc false
  def headers do
    [{'Content-Type', 'application/json'}]
  end
end
