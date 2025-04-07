defmodule BonsaiBlocks.Notion.Types.Common do
  @moduledoc """
  """

  %{
    "id" => "title",
    "type" => "title",
    "title" => [
      %{
        "type" => "text",
        "annotations" => %{
          "bold" => false,
          "code" => false,
          "color" => "default",
          "italic" => false,
          "strikethrough" => false,
          "underline" => false
        },
        "href" => nil,
        "plain_text" => "Bonsai Blocks Test Page",
        "text" => %{
          "content" => "Bonsai Blocks Test Page",
          "link" => nil
        }
      }
    ]
  }

  def rich_text(),
    do:
      {:list,
       %{
         type: :string,
         annotations: %{
           bold: :boolean,
           code: :boolean,
           color: :string,
           italic: :boolean,
           strikethrough: :boolean,
           underline: :boolean
         },
         href: {:literal, nil},
         plain_text: :string,
         text: %{
           content: :string,
           link: {:literal, nil}
         }
       }}
end
