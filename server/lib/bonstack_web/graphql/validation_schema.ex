defmodule BonstackWeb.ValidationSchema do
  use Absinthe.Schema.Notation

  object :validation_error do
    field :field, :string
    field :messages, list_of(:string)
  end

  object :validation_errors do
    field :errors, list_of(:validation_error)
  end
end
