# Metadata

An Open Graph and HTML Metadata fetcher.

This library:
- follows redirects until reaching a valid HTML page
- compensates for unencoded query params in redirect chain
- parses the page
- extracts open graph and social media metadata

## Installation

```elixir
def deps do
  [
    {:metadata, github: "zph/metadata", branch: "master"}
  ]
end
```

## Usage

```elixir
iex> Metadata.get("https://www.pbs.org")
%Metadata.Parser.Result{
  description: "Watch full episodes of your favorite PBS shows, explore music and the arts, find in-depth news analysis, and more. Home to Antiques Roadshow, Frontline, NOVA, PBS Newshour, Masterpiece and many others.",
  image: "/static/images/pbs_share_og.baebb9c305a1.png",
  title: "PBS: Public Broadcasting Service",
  url: "https://www.pbs.org"
  data: %{
    "fb:app_id" => "180911041995902",
    "fb:pages" => "19013582168",
    "og:description" => "Watch full episodes of your favorite PBS shows, explore music and the arts, find in-depth news analysis, and more. Home to Antiques Roadshow, Frontline, NOVA, PBS Newshour, Masterpiece and many others.",
    "og:image" => "/static/images/pbs_share_og.baebb9c305a1.png",
    "og:locale" => "en_US",
    "og:site_name" => "PBS.org",
    "og:title" => "PBS: Public Broadcasting Service",
    "og:type" => "website",
    "og:url" => "https://www.pbs.org",
    "twitter:card" => "summary",
    "twitter:creator" => "@PBS",
    "twitter:description" => "Watch full episodes of your favorite PBS shows, explore music and the arts, find in-depth news analysis, and more. Home to Antiques Roadshow, Frontline, NOVA, PBS Newshour, Masterpiece and many others.",
    "twitter:domain" => "pbs.org",
    "twitter:img:src" => "/static/images/pbs_share_twitter.09ff3ad01bf0.png",
    "twitter:site" => "@PBS",
    "twitter:title" => "PBS: Public Broadcasting Service"
  },
}
```

## Testing

`mix test.watch`

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc).
