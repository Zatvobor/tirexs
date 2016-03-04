defmodule Acceptances.ExamplesTest do
  use ExUnit.Case


  setup do
    Tirexs.HTTP.delete("bear_test") && :ok
  end

  test ~S(loads "examples/mapping.exs") do
    Path.expand("examples/mapping.exs") |> Tirexs.load_file
    Tirexs.Resources.exists!("bear_test")
  end

  test ~S(loads "examples/mapping_with_settings.exs") do
    Path.expand("examples/mapping_with_settings.exs") |> Tirexs.load_file
    Tirexs.Resources.exists!("bear_test")
  end

  test ~S(loads "examples/settings.exs") do
    Path.expand("examples/settings.exs") |> Tirexs.load_file
    Tirexs.Resources.exists!("bear_test")
  end

  test ~S(loads "examples/search.exs") do
    Path.expand("examples/search.exs") |> Tirexs.load_file
  end

  test ~S(loads "examples/percolator.exs") do
    Path.expand("examples/percolator.exs") |> Tirexs.load_file
  end
end
