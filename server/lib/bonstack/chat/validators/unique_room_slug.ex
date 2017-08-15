defmodule Bonstack.Chat.Validators.UniqueRoomSlug do
  use Vex.Validator

  alias Bonstack.Chat

  def validate(value, _options) do
    Vex.Validators.By.validate(value, [
      function: fn value -> !room_exists?(value) end,
      message: "has already been taken"
    ])
  end

  defp room_exists?(slug) do
    case Chat.room_by_slug(slug) do
      nil -> false
      _ -> true
    end
  end
end
