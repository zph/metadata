defmodule Metadata.Client do
  use Tesla

  adapter(Tesla.Adapter.Hackney, recv_timeout: 5_000)
  plug(Tesla.Middleware.BaseUrl, "http://")
  plug(Tesla.Middleware.FollowRedirects)
  plug(Metadata.Middleware.EncodeRedirectLink)

  plug(Tesla.Middleware.Headers, [
    {"accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"}
  ])

  plug(Tesla.Middleware.Retry,
    delay: 500,
    max_retries: 3
  )
end
