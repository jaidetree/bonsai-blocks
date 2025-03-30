# Bonsai-Blocks: Notion to HTML Elixir Library Specification

## Overview

A standalone Elixir library that:

1. Fetches blocks from a Notion database entry given an entry ID
2. Defines an associative data structure from Notion block types to a Hiccup-inspired data structure representing HTML
3. Processes the Hiccup-inspired data structures into HTML text

## Core Features

### Block Fetching

- Depth-first recursive fetching of Notion blocks
- Support for paginated responses from Notion API
- Rate limiting mechanism with exponential backoff
- Proper authentication handling via API token

### Block Types Support

Initial support for these Notion block types:
- Heading 1, 2, 3
- Paragraphs
- Code blocks
- Bulleted lists
- Numbered lists
- Images
- Embedded PDFs
- Attached files
- Horizontal rules

Rich text element support:
- Bold
- Italic
- Underline
- Strike-through
- Inline code

### HTML Transformation

- Hiccup-inspired data structure format: `[tag, attributes, content]`
- Tag can be a keyword or custom function
- Extensible mapping system for custom block transformations
- Raw HTML string output

## API Design

The library will provide three main functions:

```elixir
# Asynchronously fetch blocks with queue and rate limiting
@spec fetch_blocks(page_id :: String.t(), options :: keyword()) :: 
  {:ok, blocks :: list(map())} | {:error, reason :: term()}

# Transform blocks to HTML using provided mappings
@spec blocks_to_html(blocks :: list(map()), mapping_functions :: map()) :: 
  {:ok, html :: String.t()} | {:error, reason :: term()}

# Convenience function that does both operations
@spec page_to_html(page_id :: String.t(), options :: keyword(), mapping_functions :: map()) :: 
  {:ok, html :: String.t()} | {:error, reason :: term()}
```

## Configuration

Runtime configuration using options maps for all functions:

```elixir
# Example options for fetch_blocks
options = [
  api_token: "notion_api_token",
  rate_limit_requests_per_second: 3,
  max_retries: 5,
  backoff_initial_delay: 1000, # ms
  backoff_max_delay: 30000, # ms
  timeout: 30000 # ms
]

# Example mapping functions for blocks_to_html
mapping_functions = %{
  "heading_1" => fn block -> 
    ["h1", %{}, block.heading_1.rich_text |> transform_rich_text()]
  end,
  "paragraph" => fn block ->
    ["p", %{}, block.paragraph.rich_text |> transform_rich_text()]
  end,
  # Additional mappings
}
```

## Error Handling

- Rate limiting: Implement retry mechanism with exponential backoff
- API failures: Return detailed error tuples with context
- Notion API errors: Categorize and handle appropriately

## Implementation Details

### Block Fetching

The fetching process will:

1. Accept a Notion page ID and options (including API token)
2. Make initial request to Notion API to retrieve top-level blocks
3. For each block with children, recursively fetch child blocks
4. Handle pagination through Notion's API response cursors
5. Implement rate limiting to respect Notion's API constraints
6. Return a complete nested structure of blocks

### HTML Transformation

The transformation process will:

1. Accept a list of blocks and mapping functions
2. Iterate through each block and find appropriate mapping function
3. Apply the function to transform the block to Hiccup-inspired structure
4. Process the Hiccup structures into raw HTML strings
5. Concatenate the results into a final HTML string

## Rich Text Transformation

A helper function will transform Notion's rich text objects:

```elixir
def transform_rich_text(rich_text_list) do
  Enum.map(rich_text_list, fn item ->
    # Apply annotations (bold, italic, etc.)
    text = item.plain_text
    text = if item.annotations.bold, do: ["strong", %{}, text], else: text
    text = if item.annotations.italic, do: ["em", %{}, text], else: text
    # Additional annotations...
    text
  end)
end
```

## Testing Approach

1. Initial development with live Notion API data
2. Create test page on Notion with sample blocks of each type
3. Save API responses as JSON fixtures for test suite
4. Unit tests for each component function
5. Integration tests for complete workflows

## Documentation

The library will include:

1. Detailed module and function documentation
2. ExDoc generation for online documentation
3. Usage examples for each major function
4. Example mapping functions for common Notion blocks
5. Rate limiting configuration guidance

## Usage Example

```elixir
# Define mapping functions
mapping_functions = %{
  "heading_1" => fn block ->
    ["h1", %{class: "notion-h1"}, block.heading_1.rich_text |> transform_rich_text()]
  end,
  # Additional mappings...
}

# Fetch and convert to HTML in one step
{:ok, html} = BonsaiBlocks.page_to_html(
  "page_id_here",
  [api_token: System.get_env("NOTION_API_TOKEN")],
  mapping_functions
)

# Or in separate steps
{:ok, blocks} = BonsaiBlocks.fetch_blocks("page_id_here", [api_token: token])
{:ok, html} = BonsaiBlocks.blocks_to_html(blocks, mapping_functions)
```

## Dependencies

- HTTP client (such as Req or HTTPoison)
- JSON parser (such as Jason)
- Optional: Finch for connection pooling

## Future Enhancements

Potential areas for future development:

1. Support for additional Notion block types
2. Caching mechanism for previously fetched blocks
3. Additional output formats beyond raw HTML
4. Support for Notion database queries and filtering
5. Support for Notion comments and discussions
