ExUnit.start

defmodule UidFinder do
  defmacro find(position) do
    quote do
      key(Enum.at!(var!(index)[:mappings], unquote(position)))
    end
  end

  defmacro first do
    quote do
      key(Enum.first var!(index)[:mappings])
    end
  end

  defmacro last do
    quote do
      key(List.last var!(index)[:mappings])
    end
  end

  defmacro next(last_uid, position) do
    quote do
      uids = next_all(unquote(last_uid))
      at!(uids, unquote(position))
    end
  end

  defmacro next_all(last_uid) do
    quote do
      last_uid =  unquote(last_uid)
      dict = Enum.first List.flatten(find_by_uid(var!(index)[:mappings], last_uid))
      dict[last_uid][:properties]
    end
  end

  def find_by_uid(mappings, last_uid) do
    Enum.map mappings, fn(dict) ->
      key = helper_key(dict)
      if key == last_uid do
        dict
      else
        if dict[key][:properties] != nil do
          find_by_uid(dict[key][:properties], last_uid)
        else
          []
        end
      end
    end
  end

  def helper_key(dict) do
    Enum.first dict.keys
  end

  def at!(list, position) do
    helper_key(Enum.at!(list, position))
  end

end


defmodule ParserResponse do
  def get_body_json(body) do
    case body do
      [:ok, _, body] -> JSON.decode(to_binary(body))
      [:error, status,  message] -> message
    end
  end
end

