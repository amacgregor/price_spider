defmodule PriceSpider.BasicSpider do
  use Crawly.Spider
  @impl Crawly.Spider
  def base_url do
    "http://www.amazon.com"
  end

  @impl Crawly.Spider
  def init() do
    [
      start_urls: [
        "https://www.amazon.com/ZOTAC-Graphics-IceStorm-Advanced-ZT-A30820J-10PLHR/dp/B09PZM76MG/ref=sr_1_3?crid=1CLZE45WJ15HH&keywords=3080+graphics+card&qid=1650808965&sprefix=3080+%2Caps%2C116&sr=8-3",
        "https://www.amazon.com/GIGABYTE-Graphics-WINDFORCE-GV-N3080GAMING-OC-12GD/dp/B09QDWGNPG/ref=sr_1_4?crid=1CLZE45WJ15HH&keywords=3080+graphics+card&qid=1650808965&sprefix=3080+%2Caps%2C116&sr=8-4",
        "https://www.amazon.com/ZOTAC-Graphics-IceStorm-Advanced-ZT-A30800J-10PLHR/dp/B099ZCG8T5/ref=sr_1_5?crid=1CLZE45WJ15HH&keywords=3080+graphics+card&qid=1650808965&sprefix=3080+%2Caps%2C116&sr=8-5"
      ]
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} =
      response.body
      |> Floki.parse_document()

    price =
      document
      |> Floki.find(".a-box-group span.a-price span.a-offscreen")
      |> Floki.text()
      |> String.trim_leading()
      |> String.trim_trailing()

    %Crawly.ParsedItem{
      :items => [
        %{price: price, url: response.request_url}
      ],
      :requests => []
    }
  end
end
