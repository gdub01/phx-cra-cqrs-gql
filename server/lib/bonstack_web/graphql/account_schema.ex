defmodule BonstackWeb.AccountSchema do
  use Absinthe.Schema.Notation
  require BonstackWeb.Helpers.Payload

  alias BonstackWeb.Helpers.Payload
  alias BonstackWeb.Middleware.{HandleValidationErrors,Authentication}
  alias BonstackWeb.AccountResolver

  # return objects
  object :user, description: "A user account" do
    field :uuid, non_null(:id), description: "unique identifier"
    field :username, :string, description: "User's username"
  end

  object :session, description: "Authenticated payload" do
    field :user, :user
    field :token, non_null(:string), description: "JWT token"
  end

  # payloads
  Payload.create_payload(:user_payload, :session)

  # input objects
  input_object :create_user_params, description: "create a user" do
    field :email, non_null(:string), description: "Required email"
    field :password, non_null(:string), description: "Required password"
    field :username, non_null(:string), description: "Required username"
  end

  input_object :login_user_params, description: "params to login a user" do
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  # mutations
  object :account_mutations do

    field :create_user, type: :user_payload, description: "Create a new user" do
      arg :input, :create_user_params
      resolve &AccountResolver.create/2
    end

    field :login_user, type: :user_payload, description: "Login a user" do
      arg :login_user_input, :login_user_params
      resolve &AccountResolver.login/2
    end

  end

end
