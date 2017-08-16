defmodule BonstackWeb.Schema do
  use Absinthe.Schema

  import_types BonstackWeb.ValidationSchema
  import_types BonstackWeb.ChatSchema
  import_types BonstackWeb.AccountSchema

  query do
    import_fields :chat_queries
  end

  mutation do
    import_fields :account_mutations
    import_fields :chat_mutations
  end

end
