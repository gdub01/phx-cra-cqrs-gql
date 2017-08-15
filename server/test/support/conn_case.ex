defmodule BonstackWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      import BonstackWeb.ConnHelpers
      import BonstackWeb.Router.Helpers
      import Bonstack.Factory
      import Bonstack.Fixture

      # The default endpoint for testing
      @endpoint BonstackWeb.Endpoint
    end
  end

  setup _tags do
    Bonstack.Storage.reset!()

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
