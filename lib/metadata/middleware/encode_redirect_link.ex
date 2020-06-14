defmodule Metadata.Middleware.EncodeRedirectLink do
  @moduledoc """
  Ensure that url is url encoded to avoid 400 responses due to malformed utm_campaign
  ie
  - https://www.example.com/?utm_campaign=Cat Policy
  should be sanitized as
  - https://www.example.com/?utm_campaign=Cat%20Policy
  """
  @behaviour Tesla.Middleware

  def call(env, next, _options) do
    env
    |> encode_url()
    |> Tesla.run(next)
  end

  defp encode_url(%Tesla.Env{url: url} = env) do
    %Tesla.Env{env | url: URI.encode(url)}
  end

  defp encode_url(env), do: env
end
