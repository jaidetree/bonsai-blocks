defmodule BonsaiBlocks.Notion.API do
  @base_api_url System.get_env("NOTION_API_URL") || "https://api.notion.com/v1"

  def req(), do: Req.new(base_url: @base_api_url)

  # @spec fetch_database_entry(String.t(), BonsaiBlocks.Config.config()) :: something
  def fetch_page(config, page_id) do
    # Get api_token from config
    # Fetch from https://api.notion.com/v1/pages{page_id}
    #  - page_id should refer to id
    #  - Add "Authorization: Bearer ${api_token}" header
    #  - Parse response as json
    #  - Return json
    api_token = config.api_token

    request =
      Req.merge(req(),
        auth: {:bearer, api_token},
        headers: %{"Notion-Version" => "2022-06-28"}
      )

    response =
      Req.get!(request, url: "/pages/#{page_id}")

    response.body
  end
end

