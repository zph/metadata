defmodule MetadataTest do
  use ExUnit.Case
  doctest Metadata

  alias Metadata.Parser
  alias Metadata.Parser.Result

  @html """
  <html>
    <head>
      <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="ie=edge">
      <meta name="description" content="Site Description meta description">
      <meta name="robots" content="all">
      <meta property="og:title" content="Site">
      <meta property="og:site_name" content="Site">
      <meta property="og:type" content="website">
      <meta property="og:url" content="https://www.site.com">
      <meta property="og:image" content="https://assets.site.com/99999999999999999999999999999999.png">
      <meta property="og:image:alt" content="Site Logo">
      <meta property="og:description" content="Site Description">
      <meta name="twitter:card" content="summary_large_image">
      <meta name="twitter:site" content="@site">
      <meta name="twitter:title" content="Site">
      <meta name="twitter:description" content="Site Description for Twitter">
      <meta name="twitter:image" content="https://assets.site.com/99999999999999999999999999999999.png">
      <meta name="twitter:image:alt" content="Site Logo">
      <meta property="fb:app_id" content="999999999999999">
      <meta name="keywords" content="">
      <meta name="next-head-count" content="20">
      <meta name="viewport" content="width=device-width,minimum-scale=1,initial-scale=1">
    </head>
    <body>
      <h1>hello test page</h1>
      <img width="360" src="test.png" alt="test">
      <img width="360" alt="test2">
    </body>
  </html>
  """

  @open_graph_missing """
  <html>
    <body>
      <h1>hello test page</h1>
      <img width="360" src="test.png" alt="test">
      <img width="360" alt="test2">
    </body>
  </html>
  """

  describe "parse/1" do
    test "basic parsing" do
      assert Metadata.Parser.parse(@html) == [
               {{"charset", "utf-8"}, %{}},
               {
                 {"http-equiv", "X-UA-Compatible"},
                 %{"content" => "ie=edge"}
               },
               {
                 {"name", "description"},
                 %{"content" => "Site Description meta description"}
               },
               {{"name", "robots"}, %{"content" => "all"}},
               {{"property", "og:title"}, %{"content" => "Site"}},
               {{"property", "og:site_name"}, %{"content" => "Site"}},
               {{"property", "og:type"}, %{"content" => "website"}},
               {{"property", "og:url"}, %{"content" => "https://www.site.com"}},
               {{"property", "og:image"},
                %{"content" => "https://assets.site.com/99999999999999999999999999999999.png"}},
               {{"property", "og:image:alt"}, %{"content" => "Site Logo"}},
               {{"property", "og:description"}, %{"content" => "Site Description"}},
               {{"name", "twitter:card"}, %{"content" => "summary_large_image"}},
               {{"name", "twitter:site"}, %{"content" => "@site"}},
               {{"name", "twitter:title"}, %{"content" => "Site"}},
               {{"name", "twitter:description"}, %{"content" => "Site Description for Twitter"}},
               {{"name", "twitter:image"},
                %{"content" => "https://assets.site.com/99999999999999999999999999999999.png"}},
               {{"name", "twitter:image:alt"}, %{"content" => "Site Logo"}},
               {{"property", "fb:app_id"}, %{"content" => "999999999999999"}},
               {{"name", "keywords"}, %{"content" => ""}},
               {{"name", "next-head-count"}, %{"content" => "20"}},
               {{"name", "viewport"},
                %{"content" => "width=device-width,minimum-scale=1,initial-scale=1"}}
             ]
    end
  end

  describe "social_metadata/1" do
    test "basic parsing" do
      assert Metadata.Parser.social_metadata(@html) ==
               %{
                 "og:description" => "Site Description",
                 "og:title" => "Site",
                 "fb:app_id" => "999999999999999",
                 "og:image" => "https://assets.site.com/99999999999999999999999999999999.png",
                 "og:image:alt" => "Site Logo",
                 "og:site_name" => "Site",
                 "og:type" => "website",
                 "og:url" => "https://www.site.com",
                 "twitter:card" => "summary_large_image",
                 "twitter:description" => "Site Description for Twitter",
                 "twitter:image" =>
                   "https://assets.site.com/99999999999999999999999999999999.png",
                 "twitter:image:alt" => "Site Logo",
                 "twitter:site" => "@site",
                 "twitter:title" => "Site",
                 "description" => "Site Description meta description",
                 "keywords" => "",
                 "next-head-count" => "20",
                 "robots" => "all",
                 "viewport" => "width=device-width,minimum-scale=1,initial-scale=1"
               }
    end
  end

  describe "summary/1" do
    test "simple test" do
      assert Metadata.Parser.summary(@html) ==
               %Metadata.Parser.Result{
                 description: "Site Description",
                 title: "Site",
                 image: "https://assets.site.com/99999999999999999999999999999999.png",
                 url: "https://www.site.com",
                 data: %{
                   "fb:app_id" => "999999999999999",
                   "og:description" => "Site Description",
                   "og:image" => "https://assets.site.com/99999999999999999999999999999999.png",
                   "og:image:alt" => "Site Logo",
                   "og:site_name" => "Site",
                   "og:title" => "Site",
                   "og:type" => "website",
                   "og:url" => "https://www.site.com",
                   "twitter:card" => "summary_large_image",
                   "twitter:description" => "Site Description for Twitter",
                   "twitter:image" =>
                     "https://assets.site.com/99999999999999999999999999999999.png",
                   "twitter:image:alt" => "Site Logo",
                   "twitter:site" => "@site",
                   "twitter:title" => "Site",
                   "description" => "Site Description meta description",
                   "keywords" => "",
                   "next-head-count" => "20",
                   "robots" => "all",
                   "viewport" => "width=device-width,minimum-scale=1,initial-scale=1"
                 }
               }
    end

    test "fallback to first image as if og image tag missing" do
      %Result{image: image} = Parser.summary(@open_graph_missing)
      assert image == "test.png"
    end
  end
end
