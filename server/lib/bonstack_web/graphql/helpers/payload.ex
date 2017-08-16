defmodule BonstackWeb.Helpers.Payload do
  defmacro create_payload(payload_name, return_object_name) do
    quote location: :keep do
      union unquote(payload_name) do
        types [:validation_errors, unquote(return_object_name)]

        resolve_type fn
          %{errors: _}, _ ->
            :validation_errors
          _, _ ->
            unquote(return_object_name)
        end
      end
    end
  end
end
