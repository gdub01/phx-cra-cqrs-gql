defmodule BonstackWeb.ChatSchema do
  use Absinthe.Schema.Notation

  require BonstackWeb.Helpers.Payload

  alias BonstackWeb.Helpers.Payload
  alias BonstackWeb.Middleware.{HandleValidationErrors,Authentication}
  alias BonstackWeb.ChatResolver


  # return objects
  object :room do
    field :uuid, :id
    field :title, :string
    field :description, :string
    field :slug, :string
    field :messages, list_of(:message)
  end

  object :message do
    field :uuid, :id
    field :body, :string
  end

  object :member do
    field :uuid, :id
    field :title, :string
    field :description, :string
  end

  # payloads
  Payload.create_payload(:room_payload, :room)
  Payload.create_payload(:message_payload, :message)

  # input objects
  input_object :pagination_params do
    field :limit, non_null(:integer)
    field :offset, non_null(:integer)
  end

  input_object :create_message_params do
    field :room_slug, non_null(:string)
    field :body, non_null(:string)
  end

  input_object :create_room_params do
    field :title, non_null(:string)
    field :description, non_null(:string)
  end

  input_object :room_identifier_params do
    field :room_slug, non_null(:string)
  end

  object :chat_queries do

    field :list_rooms, list_of(:room) do
      arg :pagination_input, :pagination_params
      resolve &ChatResolver.list_rooms/2
    end

    field :messages_in_room, list_of(:message) do
      arg :pagination_input, :pagination_params
      arg :input, non_null(:room_identifier_params)
      resolve &ChatResolver.list_messages_in_room/2
    end

  end

  object :chat_mutations do

    field :create_message, type: :message_payload, description: "Create a message" do
      arg :input, non_null(:create_message_params)

      middleware Authentication
      resolve &ChatResolver.create_message/2
      middleware HandleValidationErrors
    end

    field :create_room, type: :room_payload, description: "Create a room" do
      arg :input, non_null(:create_room_params)

      middleware Authentication
      resolve &ChatResolver.create_room/2
      middleware HandleValidationErrors
    end

  end

end
