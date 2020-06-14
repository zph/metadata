defmodule Metadata.Client do
  use Tesla

  adapter(Tesla.Adapter.Hackney, recv_timeout: 5_000)
  plug(Tesla.Middleware.BaseUrl, "http://")
  plug(Tesla.Middleware.FollowRedirects)
  plug(Metadata.Middleware.EncodeRedirectLink)

  plug(Tesla.Middleware.Retry,
    delay: 500,
    max_retries: 3
  )
end
