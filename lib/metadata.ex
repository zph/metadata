defmodule Metadata do
  @moduledoc """
  Documentation for `Metadata`.
  """

  alias __MODULE__.{Client, Parser}

  def get(url) do
    with {:ok, env} <- Client.get(url) do
      Parser.summary(env.body)
    end
  end
end
