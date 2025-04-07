defmodule BonsaiBlocks.Notion.Types.Page do
  import Peri

  @moduledoc """
  Validates Page JSON data
  """

  defmodule Properties do
    def checkbox(),
      do: %{
        id: :string,
        type: {:literal, "checkbox"},
        checkbox: :boolean
      }

    def multi_select,
      do: %{
        id: :string,
        type: {:literal, "multi_select"},
        multi_select:
          {:list,
           %{
             id: :string,
             name: :string,
             color: :string
           }}
      }

    def created_time,
      do: %{
        id: :string,
        type: {:literal, "created_time"},
        created_time: :string
      }

    def rich_text,
      do: %{
        id: :string,
        type: {:literal, "rich_text"},
        rich_text: BonsaiBlocks.Notion.Types.Common.rich_text()
      }

    def relation,
      do: %{
        id: :string,
        type: {:literal, "relation"},
        relation: {:list, :map},
        has_more: :boolean
      }

    def unique_id,
      do: %{
        id: :string,
        type: {:literal, "unique_id"},
        unique_id: %{
          number: :integer,
          prefix: :string
        }
      }

    def title,
      do: %{
        id: {:literal, "title"},
        type: {:literal, "title"},
        title: BonsaiBlocks.Notion.Types.Common.rich_text()
      }

    def formula,
      do: %{
        id: :string,
        type: {:literal, "formula"},
        formula: %{
          number: {:oneof, [:float, :integer]},
          type: {:literal, "number"},
          id: :string
        }
      }

    def status,
      do: %{
        id: :string,
        type: {:literal, "status"},
        status: %{
          color: :string,
          id: :string,
          name: :string
        }
      }

    def rollup,
      do: %{
        id: :string,
        type: {:literal, "rollup"},
        rollup: %{
          function: :string,
          number: {:oneof, [:float, :integer]},
          type: {:literal, "number"}
        }
      }

    def select,
      do: %{
        id: :string,
        type: {:literal, "select"},
        select: %{
          color: :string,
          id: :string,
          name: :string
        }
      }

    def last_edited_time,
      do: %{
        id: :string,
        type: {:literal, "last_edited_time"},
        last_edited_time: :string
      }
  end

  def list_property_validators do
    BonsaiBlocks.Notion.Types.Page.Properties.__info__(:functions)
    |> Enum.map(fn {k, _v} ->
      apply(BonsaiBlocks.Notion.Types.Page.Properties, k, [])
    end)
  end

  def properties,
    do: {:map, :string, {:oneof, list_property_validators()}}

  def page,
    do: %{
      id: :string,
      in_trash: :boolean,
      archived: :boolean,
      object: :string,
      properties: properties()
    }
end
