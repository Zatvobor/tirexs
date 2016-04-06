#
# Run this example from console manually:
#
#   $ mix run -r examples/bulk.exs
#   # => ?
#
# Run this example from Elixir environment (`iex -S mix`):
#
#   iex> Path.expand("examples/bulk.exs") |> Tirexs.load_file
#
import Tirexs.Bulk

payload = bulk do
  index [ index: "bear_test", type: "blog" ], [
    [id: 1, title: "My second blog post"]
    # ...
  ]

  # update [ index: "bear_test", type: "blog"], [
  #   [
  #     doc: [id: 1, _retry_on_conflict: 3, title: "[updated] My first blog post"],
  #     fields: ["_source"],
  #   ]
  # ]
end

Tirexs.bump!(payload)._bulk()
