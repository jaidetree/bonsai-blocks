Code.require_file("lib/bonsai_blocks/config.ex")
Code.require_file("lib/bonsai_blocks/notion/api.ex")
Code.require_file("lib/bonsai_blocks/notion/types/page.ex")

defmodule Test do
  def record_response(body) do
    encoded = Jason.encode!(body, pretty: true)
    File.write!("tmp/notion-page.json", encoded)
    body
  end

  def load_json(file) do
    case File.read(file) do
      {:ok, contents} ->
        IO.puts("Loading from JSON file")
        Jason.decode(contents)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def fetch_json(config) do
    IO.puts("Fetching JSON from Notion")

    config
    |> BonsaiBlocks.Notion.API.fetch_page(System.get_env("NOTION_DB_PAGE_ID"))
  end

  def get(config) do
    json_result = load_json("tmp/notion-page.json")

    case json_result do
      {:ok, json} ->
        json

      {:error, _reason} ->
        fetch_json(config)
        |> record_response()
    end
  end
end

config = BonsaiBlocks.Config.create!(api_token: System.get_env("NOTION_API_KEY"))

# title = %{
#   "id" => "title",
#   "type" => "title",
#   "title" => [
#     %{
#       "type" => "text",
#       "annotations" => %{
#         "bold" => false,
#         "code" => false,
#         "color" => "default",
#         "italic" => false,
#         "strikethrough" => false,
#         "underline" => false
#       },
#       "href" => nil,
#       "plain_text" => "Bonsai Blocks Test Page",
#       "text" => %{
#         "content" => "Bonsai Blocks Test Page",
#         "link" => nil
#       }
#     }
#   ]
# }
#
# properties = %{
#   "Title" => title
# }
#
# Peri.validate(BonsaiBlocks.Notion.Types.Page.properties(), properties)
# |> IO.inspect()

Test.get(config)
|> BonsaiBlocks.Notion.Types.Page.page()
|> IO.inspect()

# result = BonsaiBlocks.Notion.Types.Page.page(page)

# IO.inspect(result, pretty: true)
