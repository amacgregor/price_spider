defmodule PriceSpider.AmazonSpider do
  use Crawly.Spider
  @impl Crawly.Spider
  def base_url do
    "http://www.amazon.com"
  end

  @impl Crawly.Spider
  def init() do
    [
      start_urls: [
        "https://www.amazon.com/s?k=3080+video+card&rh=n%3A17923671011%2Cn%3A284822&dc&qid=1650819793&rnid=2941120011&sprefix=3080+video%2Caps%2C107&ref=sr_nr_n_2"
      ]
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} =
      response.body
      |> Floki.parse_document()

    # Getting search result urls
    urls =
      document
      |> Floki.find("div.s-result-list a.a-link-normal")
      |> Floki.attribute("href")

    # Convert URLs into requests
    requests =
      Enum.map(urls, fn url ->
        url
        |> build_absolute_url(response.request_url)
        |> Crawly.Utils.request_from_url()
      end)

    name =
      document
      |> Floki.find("span#productTitle")
      |> Floki.text()

    price =
      document
      |> Floki.find(".a-box-group span.a-price span.a-offscreen")
      |> Floki.text()
      |> String.trim_leading()
      |> String.trim_trailing()

    %Crawly.ParsedItem{
      :requests => requests,
      :items => [
        %{name: name, price: price, url: response.request_url}
      ]
    }
  end

  def build_absolute_url(url, request_url) do
    URI.merge(request_url, url) |> to_string()
  end
end
