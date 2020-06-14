defmodule Metadata.Parser do
  def parse(html) do
    {:ok, document} = Floki.parse_document(html)

    document
    |> Floki.find("meta")
    |> Enum.map(fn {"meta", [{attr, value} | rest], _children} ->
      {{attr, value}, rest |> Enum.into(%{})}
    end)
  end

  def social_metadata_raw(html) do
    parse(html)
    |> Enum.filter(fn
      {{"name", _}, _} -> true
      {{"property", "og:" <> _}, _} -> true
      {{"property", "fb:" <> _}, _} -> true
      _ -> false
    end)
  end

  def social_metadata(html) do
    social_metadata_raw(html)
    |> Enum.map(fn {{_attr, tag}, %{"content" => content}} ->
      {tag, content}
    end)
    |> Enum.into(%{})
  end

  defmodule __MODULE__.Result do
    defstruct [:title, :description, :image, :url, :data]
  end

  def summary(html) do
    meta =
      html
      |> social_metadata()

    %__MODULE__.Result{}
    |> Map.put(:description, do_description(meta))
    |> Map.put(:title, do_title(meta))
    |> Map.put(:image, do_image(meta, html))
    |> Map.put(:url, do_url(meta))
    |> Map.put(:data, meta)
    |> ensure_fully_qualified_image_urls()
  end

  def do_description(%{"og:description" => description}), do: description
  def do_description(%{"description" => description}), do: description
  def do_description(%{"twitter:description" => description}), do: description
  def do_description(_), do: nil

  def do_title(%{"og:title" => value}), do: value
  def do_title(%{"twitter:title" => value}), do: value
  def do_title(_), do: nil

  def do_image(%{"og:image" => value}, _), do: value
  def do_image(%{"twitter:image" => value}, _), do: value

  # Get first image in article if og and social images are missing
  def do_image(_meta, html) do
    with {:ok, document} <- Floki.parse_document(html),
         [{"img", attr, []} | _] <- Floki.find(document, "img"),
         image when is_bitstring(image) <- attr |> Enum.into(%{}) |> Map.get("src") do
      image
    else
      _ -> nil
    end
  end

  def ensure_fully_qualified_image_urls(%__MODULE__.Result{image: nil} = result), do: result
  def ensure_fully_qualified_image_urls(%__MODULE__.Result{url: nil} = result), do: result

  @doc """
  Guard against sites that use relative links and in that case merge in the fully qualified link
  """
  def ensure_fully_qualified_image_urls(%__MODULE__.Result{image: image, url: url} = result) do
    sanitized_image_url =
      case URI.parse(image) do
        %URI{host: nil} = uri -> URI.parse(url) |> Map.merge(uri, fn _k, v1, v2 -> v2 || v1 end)
        uri -> uri
      end
      |> URI.to_string()

    %__MODULE__.Result{result | image: sanitized_image_url}
  end

  def do_url(%{"og:url" => value}), do: value
  def do_url(_), do: nil
end
