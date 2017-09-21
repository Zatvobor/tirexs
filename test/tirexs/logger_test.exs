Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Tirexs.LoggerTest do
  use ExUnit.Case

  import ExUnit.CaptureLog
  import ExUnit.CaptureIO

  @url "http://127.0.0.1/foo"
  @headers Tirexs.HTTP.Shared.headers

  setup do
    Application.put_env(:tirexs, :log, true)

    on_exit fn ->
      Application.delete_env(:tirexs, :log)
    end
  end

  test :to_curl do
    capture_io(:error_logger, fn ->
      assert Tirexs.Logger.to_curl([d: 4]) == :ok
      assert Tirexs.Logger.to_curl(JSX.encode!([d: 4])) == :ok
    end)
  end

  test "log_command logs a curl command without a body" do
    log = capture_log fn ->
      Tirexs.Logger.log_command(:get, {@url, @headers})
    end

    assert log =~ ~s(curl -XGET http://127.0.0.1/foo -H 'Content-Type:application/json')
  end

  test "log_command logs a curl command with a body" do
    log = capture_log fn ->
      Tirexs.Logger.log_command(:get, {@url, @headers, "application/json", "{\"foo\":\"bar\"}"})
    end

    assert log =~ ~s(curl -XGET http://127.0.0.1/foo -H 'Content-Type:application/json' -d '{\n  \"foo\": \"bar\"\n}')
  end
end
