defmodule Tirexs.Logger do
  @moduledoc false

  require Logger

  @doc """
  Logs all requests as CURL commands.
  """
  def log_command(method, request) do
    if Tirexs.get_env(:log) do
      method
      |> to_curl_command(request)
      |> Logger.debug()
    end
  end

  @doc false
  def to_curl(data) do
    case JSX.is_json?(data) do
      true  -> log(data)
      false -> log(JSX.encode!(data))
    end
  end

  defp log(json) do
    :error_logger.info_msg(JSX.prettify!(json))
  end

  defp to_curl_command(method, {url, headers}) do
    "curl"
    |> put_curl_method(method)
    |> put_curl_url(url)
    |> put_curl_headers(headers)
  end
  defp to_curl_command(method, {url, headers, _content_type, []}) do
    to_curl_command(method, {url, headers})
  end
  defp to_curl_command(method, {url, headers, _content_type, body}) do
    method
    |> to_curl_command({url, headers})
    |> put_curl_body(body)
  end

  defp put_curl_method(curl, method) do
    verb =
      method
      |> Atom.to_string()
      |> String.upcase()

    curl <> " -X#{verb}"
  end

  defp put_curl_url(curl, url) do
    curl <> " #{url}"
  end

  defp put_curl_headers(curl, headers) do
    Enum.reduce headers, curl, fn({key, value}, acc) ->
      acc <> " -H '#{key}:#{value}'"
    end
  end

  defp put_curl_body(curl, body) do
    curl <> " -d '#{JSX.prettify!(body)}'"
  end
end
