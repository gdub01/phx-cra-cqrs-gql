defmodule Bonstack.Chat.Slugger do
  alias Bonstack.Chat

  @doc """
  Slugify the given text and ensure that it is unique.

  A slug will contain only alphanumeric characters (`a-z`, `0-9`) and the default separator character (`-`).

  If the generated slug is already taken, append a numeric suffix and keep incrementing until a unique slug is found.

  ## Examples

    - "Example room" => "example-room", "example-room-2", "example-room-3", etc.
  """
  @spec slugify(String.t) :: {:ok, slug :: String.t} | {:error, reason :: term}
  def slugify(title) do
    title
    |> Slugger.slugify_downcase()
    |> ensure_unique_slug()
  end

  # Ensure the given slug is unique, if not increment the suffix and try again.
  defp ensure_unique_slug(slug, suffix \\ 1)
  defp ensure_unique_slug("", _suffix), do: ""
  defp ensure_unique_slug(slug, suffix) do
    suffixed_slug = suffixed(slug, suffix)

    case exists?(suffixed_slug) do
      true -> ensure_unique_slug(slug, suffix + 1)
      false -> {:ok, suffixed_slug}
    end
  end

  # Does the slug exist?
  defp exists?(slug) do
    case Chat.room_by_slug(slug) do
      nil -> false
      _ -> true
    end
  end

  defp suffixed(slug, 1), do: slug
  defp suffixed(slug, suffix), do: slug <> "-" <> to_string(suffix)
end
