defmodule Bonstack.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Bonstack.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Bonstack.Factory
      import Bonstack.Fixture
      import Bonstack.DataCase
    end
  end

  setup _tags do
    Bonstack.Storage.reset!()
    
    :ok
  end
end
