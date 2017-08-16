defmodule BonstackWeb.Middleware.HandleValidationErrors do
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    case resolution.errors do

      [%{message: x, details: x}] = errors when is_list(errors) ->
        field_errors = Enum.map errors, & %{field: &1.message, messages: &1.details}
        resolution
          |> Absinthe.Resolution.put_result({:ok, %{errors: field_errors}})
          |> Map.put(:errors, [])

      _ -> resolution
    end
  end
end
