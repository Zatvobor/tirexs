defmodule Tirexs.ElasticSettings do

  defmacro __using__(_) do
    quote do
      defrecordp :elastic_settings,  [port: 9200, uri: "127.0.0.1", user: nil, pass: nil]

      def port(elastic_settings(port: port)) do
        port
      end

      def port(port, rec) do
        elastic_settings(rec, port: port)
      end

      def uri(elastic_settings(uri: uri)) do
        uri
      end

      def uri(uri, rec) do
        elastic_settings(rec, uri: uri)
      end

      def user(elastic_settings(user: user)) do
        user
      end

      def user(user, rec) do
        elastic_settings(rec, user: user)
      end

      def pass(elastic_settings(pass: pass)) do
        pass
      end

      def pass(pass, rec) do
        elastic_settings(rec, pass: pass)
      end

      def new(rec) do
        rec
      end

      def new(opts, rec) do
        set(opts, rec)
      end



      defp set([], rec) do
        rec
      end

      defp set([h|t], rec) do
        h = [h]
        key = Enum.first Dict.keys(h)
        value = h[key]
        rec = case key do
          :port -> rec.port(value)
          :uri  -> rec.uri(value)
          :user -> rec.user(value)
          :pass -> rec.pass(value)
          _     -> rec
        end
        set(t, rec)
      end
    end
  end




end