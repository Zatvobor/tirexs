defmodule Tirexs.HTTP.AWS do
  import Tirexs.HTTP.Shared

  @aws_es_service_name "es"

  @doc false
  def do_request(method, url, body \\ []) do
    :ok = :ssl.start

    case method do
      :get ->
        signed_url = "GET" |> sign_url(url) |> String.to_char_list()
        method |> request({signed_url, []}, [], []) |> response()
      :head ->
        signed_url = "HEAD" |> sign_url(url) |> String.to_char_list()
        method |> request({signed_url, []}, [], []) |> response()
      m when m == :delete or m == :put or m == :post ->
        aws_auth_headers = stringify_keys_and_values(headers)
        signed_headers = method |> to_string |> sign_headers(url, aws_auth_headers, body) |> char_list_keys_and_values
        { url, content_type, options } = { String.to_char_list(url), 'application/json', [body_format: :binary] }
        method |> request({url, signed_headers, content_type, body}, [], options) |> response()
    end
  end

  def sign_url(method, url, headers \\ %{}) do
    AWSAuth.sign_url(access_key_id, secret_access_key, method, url, aws_region, @aws_es_service_name, headers)
  end

  def sign_headers(method, url, headers, body) do
    AWSAuth.sign_authorization_header(access_key_id, secret_access_key, method, url, aws_region, @aws_es_service_name, headers, body)
  end

  defp stringify_keys_and_values(headers) do
    headers
    |> Enum.map(fn {key, value} -> {to_string(key), to_string(value)} end)
    |> Enum.into(%{})
  end

  defp char_list_keys_and_values(headers) do
    headers
    |> Enum.map(fn {key, value} -> {to_char_list(key), to_char_list(value)} end)
  end

  def access_key_id, do: Application.get_env(:tirexs, :aws)[:access_key_id]
  def secret_access_key, do: Application.get_env(:tirexs, :aws)[:secret_access_key]
  def aws_region, do: Application.get_env(:tirexs, :aws)[:region]
end
