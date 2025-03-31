# Bonsai-Blocks Implementation Prompt Plan

This document contains a series of prompts designed for a code-generation LLM to implement the Bonsai-Blocks Elixir library step by step. Each prompt builds on the previous ones, ensuring incremental progress with no major jumps in complexity. Follow these prompts in sequence to develop a complete, well-structured library.

## Prompt 1: Project Setup and Basic Structure

This prompt creates the initial project structure with dependencies and basic module scaffolding.

```text
Update the mix.exs file with the following dependencies:
- Jason for JSON parsing
- Req for HTTP requests
- Ex_doc for documentation

Create the following empty module files:
1. lib/bonsai_blocks.ex - Main API module
2. lib/bonsai_blocks/config.ex - Configuration handling
3. lib/bonsai_blocks/api.ex - Notion API communication
4. lib/bonsai_blocks/html.ex - HTML generation
5. lib/bonsai_blocks/transform.ex - Block transformation

Include a basic README.md file that describes the project's purpose: a library that fetches blocks from Notion and converts them to HTML. The library should implement three main functions:
- fetch_blocks/2
- blocks_to_html/2
- page_to_html/3

Follow Elixir best practices for project structure and module documentation.
```

## Prompt 2: Configuration Module Implementation

This prompt implements the configuration module to handle library options.

```text
Implement the BonsaiBlocks.Config module for the bonsai_blocks project. This module should:

1. Define default configuration options including:
   - api_token (required for Notion API authentication)
   - rate_limit_requests_per_second (default: 3)
   - max_retries (default: 5)
   - backoff_initial_delay (default: 1000 ms)
   - backoff_max_delay (default: 30000 ms)
   - timeout (default: 30000 ms)

2. Include a function to merge provided options with defaults:
   - merge_options/1 that takes user options and returns complete options with defaults

3. Include validation for the required api_token:
   - validate_options/1 that checks if api_token is present and valid

4. Add proper typespec definitions and documentation

The module should follow Elixir best practices and include appropriate error handling for missing or invalid configuration.

Here's the module structure to implement:

defmodule BonsaiBlocks.Config do
  @moduledoc """
  Configuration handling for BonsaiBlocks
  """

  # Define default options
  # Implement merge_options/1
  # Implement validate_options/1
  # Add any helper functions needed
end
```

## Prompt 3: API Client - Basic Implementation

This prompt implements the basic API client for communicating with the Notion API.

```text
Implement the BonsaiBlocks.Notion.API module for the bonsai_blocks project. This module should handle communication with the Notion API. Build on the previously created Config module for configuration.

The implementation should:

1. Use the Req library for HTTP requests
2. Define the Notion API base URL as a module attribute
3. Include proper authentication using the Notion API token from configuration
4. Implement a basic get_blocks/2 function that:
   - Takes a block_id and options
   - Validates the block_id format
   - Makes a request to the Notion blocks endpoint
   - Handles the response and returns either {:ok, blocks} or {:error, reason}
5. Include proper error handling for various HTTP and API errors

Make sure to:
- Add appropriate typespecs
- Document all public functions
- Include logging for requests and responses
- Handle JSON serialization/deserialization using Jason

Here's the module structure to implement:

defmodule BonsaiBlocks.API do
  @moduledoc """
  Handles communication with the Notion API
  """

  require Logger

  # Define Notion API constants
  # Implement get_blocks/2
  # Add helper functions for authentication, requests, error handling
end
```

## Prompt 4: First Integration Test

This prompt creates a simple test file to verify the basic API functionality.

```text
Create a test file for the BonsaiBlocks.API module that tests the basic functionality of fetching blocks from the Notion API. Use ExUnit's test mocking capabilities to avoid making actual API calls.

The test should:

1. Set up a mock for the Req library to simulate API responses
2. Test the successful fetching of blocks with a mocked successful response
3. Test error handling with various error responses (unauthorized, rate limited, etc.)
4. Include at least one test for configuration validation

Create the test file at test/bonsai_blocks/api_test.exs with proper setup and teardown. Include a sample Notion API response as a fixture for testing.

Follow Elixir testing best practices and make sure the tests are comprehensive but focused on the specific functionality being tested.
```

## Prompt 5: HTML Generation - Hiccup Format

This prompt implements the HTML generation module for converting a Hiccup-inspired data structure to HTML.

```text
Implement the BonsaiBlocks.HTML module for the bonsai_blocks project. This module should handle converting a Hiccup-inspired data structure to HTML.

The Hiccup format is: [tag, attributes, content], where:
- tag is an atom like :div, :p, :h1, etc.
- attributes is a map of attributes like %{class: "my-class", id: "my-id"}
- content is either a string, another Hiccup structure, or a list of Hiccup structures

Implement the following:

1. A hiccup_to_html/1 function that converts the Hiccup data structure to an HTML string
2. Support for nested elements
3. Proper escaping of HTML attributes and content
4. Special handling for void elements like :img, :br, :hr

Include appropriate typespecs, documentation, and error handling.

Here's the module structure to implement:

defmodule BonsaiBlocks.HTML do
  @moduledoc """
  Converts Hiccup-inspired data structures to HTML
  """

  # Define hiccup_to_html/1
  # Add helpers for attributes, content, and escaping
  # Handle special cases like void elements
end
```

## Prompt 6: Block Transformation - Basic Mappers

This prompt implements the basic block transformation module with mappers for common block types.

```text
Implement the BonsaiBlocks.Transform module for the bonsai_blocks project. This module should handle transforming Notion API block objects into Hiccup-inspired data structures for HTML generation.

Implement the following:

1. A transform_blocks/2 function that:
   - Takes a list of blocks and a map of custom mappings
   - Applies the appropriate mapper function to each block
   - Returns a list of Hiccup data structures

2. Default mappers for these basic block types:
   - Paragraph blocks (map to <p> tags)
   - Heading 1, 2, 3 blocks (map to <h1>, <h2>, <h3> tags)
   - Text content within blocks (plain text only for now)

3. A system to allow custom mappers to override defaults

4. Simple error handling for unknown block types

The implementation should be extensible for adding more block types later. Include appropriate typespecs and documentation.

Here's the module structure to implement:

defmodule BonsaiBlocks.Transform do
  @moduledoc """
  Transforms Notion blocks to Hiccup-inspired data structures
  """

  # Define transform_blocks/2
  # Implement default_mappings/0
  # Implement individual mappers for each block type
  # Add helpers for finding and applying mappers
end
```

## Prompt 7: Main Module Integration

This prompt implements the main BonsaiBlocks module that ties everything together.

```text
Implement the main BonsaiBlocks module that integrates all the previously created modules (Config, API, HTML, Transform) to provide the public API for the library.

Implement the following functions as specified in the project requirements:

1. fetch_blocks/2:
   - Takes a page_id and options
   - Uses BonsaiBlocks.API to fetch blocks from Notion
   - Returns {:ok, blocks} or {:error, reason}

2. blocks_to_html/2:
   - Takes a list of blocks and mapping_functions
   - Uses BonsaiBlocks.Transform to transform blocks to Hiccup structures
   - Uses BonsaiBlocks.HTML to convert Hiccup to HTML
   - Returns {:ok, html_string} or {:error, reason}

3. page_to_html/3:
   - Takes a page_id, options, and mapping_functions
   - Combines fetch_blocks and blocks_to_html for convenience
   - Returns {:ok, html_string} or {:error, reason}

Make sure to add proper typespecs, documentation, and examples in the documentation. Handle configuration validation and error cases appropriately.

Here's the module structure to implement:

defmodule BonsaiBlocks do
  @moduledoc """
  BonsaiBlocks: Convert Notion blocks to HTML
  """

  # Implement fetch_blocks/2
  # Implement blocks_to_html/2
  # Implement page_to_html/3
  # Add any helper functions needed
end
```

## Prompt 8: Rich Text Handling

This prompt enhances the Transform module to handle rich text with annotations.

```text
Enhance the BonsaiBlocks.Transform module to support Notion's rich text elements with annotations. This builds on the existing Transform module.

Implement the following:

1. A transform_rich_text/1 function that:
   - Takes a list of rich_text objects from Notion API
   - Processes annotations (bold, italic, underline, etc.)
   - Returns a Hiccup structure or list of structures

2. Support for these annotations:
   - Bold (convert to <strong> tags)
   - Italic (convert to <em> tags)
   - Underline (convert to <u> tags)
   - Strikethrough (convert to <s> tags)
   - Code (convert to <code> tags)

3. Support for nested annotations (e.g., bold and italic together)

4. Update the existing block mappers to use the new transform_rich_text function

The implementation should handle the structure of Notion's rich_text objects, which contain annotations and text content. Include appropriate typespecs and documentation.

Here's a sketch of the functionality to implement:

```elixir
def transform_rich_text(rich_text_list) do
  Enum.map(rich_text_list, fn item ->
    text = item.plain_text
    # Apply annotations in appropriate order
    text = if item.annotations.bold, do: ["strong", %{}, text], else: text
    text = if item.annotations.italic, do: ["em", %{}, text], else: text
    # More annotations...
    text
  end)
end
```

Update the block mappers to use this new function.
```

## Prompt 9: API Client - Pagination Support

This prompt enhances the API client to handle pagination of Notion API responses.

```text
Enhance the BonsaiBlocks.API module to support pagination when fetching blocks from the Notion API. The Notion API returns paginated results with a "next_cursor" when there are more blocks to fetch.

Implement the following:

1. Update the get_blocks/2 function to:
   - Handle the "next_cursor" in the response
   - Support a start_cursor parameter in the options
   - Detect when there are more blocks to fetch

2. Implement a get_all_blocks/2 function that:
   - Automatically fetches all pages of blocks
   - Handles rate limiting between requests
   - Aggregates the results into a single list
   - Returns {:ok, all_blocks} or {:error, reason}

3. Add configuration options for pagination:
   - page_size (default: 100)
   - max_pages (default: nil, meaning fetch all pages)

4. Implement proper error handling for pagination-related issues

Make sure the implementation maintains compatibility with the existing code and follows Elixir best practices for handling async operations and recursion.

Here's a sketch of the functionality to implement:

```elixir
def get_all_blocks(block_id, options \\ []) do
  # Implementation using recursion or a Stream
  # to fetch all pages of blocks
end

defp fetch_page_of_blocks(block_id, options, results \\ []) do
  # Recursive implementation for fetching pages
  # Stop when has_more is false or max_pages is reached
end
```
```

## Prompt 10: Recursive Block Fetching

This prompt enhances the API client to recursively fetch child blocks.

```text
Enhance the BonsaiBlocks.API module to support recursive fetching of child blocks. Notion's API separates parent blocks from their children, so we need to fetch children separately and build a nested structure.

Implement the following:

1. Update the get_blocks/2 function to detect blocks with children (has_children: true)

2. Implement a get_block_with_children/2 function that:
   - Fetches a block by ID
   - Checks if it has children
   - Fetches all children recursively
   - Nests children under their parent block
   - Handles pagination for each level of children

3. Implement a get_all_blocks_with_children/2 function that:
   - Fetches all top-level blocks
   - Recursively fetches all children
   - Returns a fully nested block structure
   - Supports depth limiting via options

4. Add configuration options:
   - fetch_children (default: true)
   - max_depth (default: nil, meaning no limit)

5. Update the data structure to include a "children" key for blocks with children

Make sure to handle rate limiting appropriately when making multiple requests for children. Include proper error handling and documentation.

Here's a sketch of the functionality to implement:

```elixir
def get_block_with_children(block_id, options \\ []) do
  # Fetch the block
  # Fetch its children if applicable
  # Add children to the block
end

def get_all_blocks_with_children(block_id, options \\ []) do
  # Fetch all top-level blocks
  # Recursively fetch children for each block
  # Return nested structure
end
```
```

## Prompt 11: Rate Limiting and Exponential Backoff

This prompt implements rate limiting and exponential backoff for API requests.

```text
Enhance the BonsaiBlocks.API module to implement proper rate limiting and exponential backoff for API requests. The Notion API has rate limits, and we need to handle them gracefully.

Implement the following:

1. A RateLimiter module or functionality that:
   - Limits requests to the configured requests_per_second
   - Adds appropriate delays between requests
   - Tracks and manages request quotas

2. An exponential backoff mechanism that:
   - Retries failed requests with increasing delays
   - Respects the max_retries configuration
   - Handles specific error types appropriately (e.g., 429 Too Many Requests)

3. Update the API request functions to use these mechanisms:
   - Apply rate limiting to all requests
   - Add retry logic with backoff
   - Log retries and rate limiting events

4. Add configuration options:
   - rate_limit_requests_per_second (already defined in Config)
   - max_retries (already defined in Config)
   - backoff_initial_delay (already defined in Config)
   - backoff_max_delay (already defined in Config)

The implementation should be robust and handle various error cases gracefully. Use Elixir's Process capabilities for tracking rate limits.

Here's a sketch of some functions to implement:

```elixir
defmodule BonsaiBlocks.API.RateLimiter do
  # Functions for rate limiting
end

defp make_request_with_backoff(url, headers, options, retry_count \\ 0) do
  # Implementation with exponential backoff
end
```

Integrate this with the existing API functions.
```

## Prompt 12: List Block Types Support

This prompt enhances the Transform module to support list block types.

```text
Enhance the BonsaiBlocks.Transform module to support bulleted and numbered list block types. Notion represents lists as individual list item blocks that need to be grouped together.

Implement the following:

1. Add support for these block types:
   - bulleted_list_item (map to <li> within <ul>)
   - numbered_list_item (map to <li> within <ol>)

2. Implement list grouping functionality:
   - Group consecutive list items of the same type
   - Generate proper <ul> or <ol> wrappers
   - Handle mixed list types appropriately

3. Update transform_blocks/2 to handle list grouping:
   - Process blocks in sequence
   - Detect list item blocks
   - Group them appropriately
   - Keep non-list blocks as is

4. Ensure rich text handling works within list items

Make sure the implementation maintains compatibility with the existing code and handles nesting of lists and other block types correctly.

Here's a sketch of the functionality to implement:

```elixir
def process_list_items(blocks, acc \\ [], current_list \\ nil) do
  # Process blocks sequentially
  # Group consecutive list items
  # Output proper HTML structure
end

def transform_bulleted_list_item(block) do
  # Transform to Hiccup format
end

def transform_numbered_list_item(block) do
  # Transform to Hiccup format
end
```

Update the transform_blocks/2 function to use this list processing.
```

## Prompt 13: Code Blocks and Horizontal Rules

This prompt implements support for code blocks and horizontal rules.

```text
Enhance the BonsaiBlocks.Transform module to support code blocks and horizontal rules (dividers). This builds on the existing Transform module.

Implement the following:

1. Add support for code blocks:
   - Map code blocks to <pre><code> tags
   - Extract language information for syntax highlighting
   - Add language class to code element (e.g., class="language-elixir")
   - Properly escape code content

2. Add support for divider blocks:
   - Map divider blocks to <hr> tags
   - Handle any attributes or styling

3. Update the default_mappings/0 function to include these new block types

4. Ensure these new block types integrate well with existing block types and transformations

Make sure to handle special characters in code blocks properly and maintain proper HTML structure.

Here's a sketch of the functionality to implement:

```elixir
def transform_code_block(block) do
  language = get_in(block, [:code, :language]) || "plaintext"
  code_content = get_in(block, [:code, :rich_text]) |> extract_plain_text()

  ["pre", %{},
    ["code", %{class: "language-#{language}"}, code_content]
  ]
end

def transform_divider(_block) do
  ["hr", %{}, ""]
end
```

Add these to your default mappings and ensure they're properly tested.
```

## Prompt 14: Media Blocks Support

This prompt implements support for image and file blocks.

```text
Enhance the BonsaiBlocks.Transform module to support media blocks including images, files, and PDF embeds. This builds on the existing Transform module.

Implement the following:

1. Add support for image blocks:
   - Map image blocks to <img> tags
   - Extract image URL and alt text
   - Handle captions as figcaption elements
   - Support both external and Notion-hosted images

2. Add support for file blocks:
   - Map file blocks to <a> tags for downloading
   - Extract file URL and name
   - Handle different file types appropriately

3. Add support for PDF embeds:
   - Map PDF blocks to <object> or <iframe> tags
   - Provide fallback content for browsers without PDF support

4. Update the default_mappings/0 function to include these new block types

Make sure to handle URLs safely and generate appropriate HTML attributes for each type.

Here's a sketch of the functionality to implement:

```elixir
def transform_image_block(block) do
  url = get_in(block, [:image, :file, :url]) || get_in(block, [:image, :external, :url])
  caption = get_in(block, [:image, :caption]) |> transform_rich_text()

  if caption do
    ["figure", %{},
      [
        ["img", %{src: url, alt: extract_plain_text(caption)}, ""],
        ["figcaption", %{}, caption]
      ]
    ]
  else
    ["img", %{src: url, alt: ""}, ""]
  end
end

def transform_file_block(block) do
  # Similar implementation for files
end

def transform_pdf_block(block) do
  # Similar implementation for PDFs
end
```

Add these to your default mappings and ensure they're properly tested.
```

## Prompt 15: Custom Mapping Function Support

This prompt enhances the Transform module to better support custom mapping functions.

```text
Enhance the BonsaiBlocks.Transform module to provide better support for custom mapping functions. This allows users to customize how blocks are transformed to HTML.

Implement the following:

1. Refine the transform_blocks/2 function to:
   - Better handle merging of default and custom mappings
   - Support fallback for unknown block types
   - Provide more context to custom mappers

2. Create helper functions for common mapping operations:
   - Extract plain text from rich text
   - Generate common HTML structures
   - Handle common attributes

3. Document the mapping function format and expectations:
   - Input: a single block from the Notion API
   - Output: a Hiccup-inspired data structure

4. Create example custom mappings for documentation:
   - Custom heading with classes
   - Custom paragraph with wrapper
   - Custom image handling

Make sure the implementation maintains compatibility with the existing code and enhances flexibility for users.

Here's a sketch of some functionality to implement:

```elixir
def transform_blocks(blocks, custom_mappings \\ %{}) do
  # Merge custom_mappings with default_mappings
  # Apply appropriate mapper to each block
  # Handle unknown block types gracefully
end

def extract_plain_text(rich_text) do
  # Helper to extract plain text from rich text
end

# Example custom mappers for documentation
def custom_heading_mapper(block) do
  heading_level = block_type_to_heading_level(block.type)
  text = get_in(block, [String.to_atom(block.type), :rich_text]) |> transform_rich_text()

  [String.to_atom("h#{heading_level}"), %{class: "custom-heading"}, text]
end
```

Document these functions and provide clear examples for users.
```

## Prompt 16: Documentation and Examples

This prompt focuses on improving documentation and adding examples.

```text
Enhance the documentation throughout the BonsaiBlocks library to ensure it's comprehensive and user-friendly. Add examples that demonstrate common usage patterns.

Implement the following:

1. Improve module documentation (@moduledoc) for all modules:
   - Add clear descriptions of module purposes
   - Explain key concepts and patterns
   - Add usage examples where appropriate

2. Improve function documentation (@doc) for all public functions:
   - Clear descriptions of parameters and return values
   - Examples of usage
   - Explanation of error cases

3. Add typespecs (@spec) for all public functions

4. Create comprehensive examples in the main module:
   - Basic usage example for page_to_html/3
   - Example of custom mapping functions
   - Example of configuration options

5. Create a comprehensive guide in the README:
   - Installation instructions
   - Quick start guide
   - Configuration options
   - Custom mapping examples
   - Common issues and solutions

Make sure the documentation adheres to Elixir documentation best practices and is clear for users of different experience levels.

Here's a sketch of what to implement:

```elixir
@moduledoc """
BonsaiBlocks: Convert Notion blocks to HTML

This library provides functionality to fetch blocks from Notion and convert them to HTML.
It supports a variety of block types and allows for custom transformations.

## Basic Usage

```elixir
# Fetch blocks and convert to HTML in one step
{:ok, html} = BonsaiBlocks.page_to_html(
  "page_id_here",
  [api_token: System.get_env("NOTION_API_TOKEN")]
)

# Or in separate steps
{:ok, blocks} = BonsaiBlocks.fetch_blocks("page_id_here", [api_token: token])
{:ok, html} = BonsaiBlocks.blocks_to_html(blocks)
```

## Custom Mappings

You can customize how blocks are transformed to HTML:

```elixir
mapping_functions = %{
  "heading_1" => fn block ->
    ["h1", %{class: "custom-heading"},
     BonsaiBlocks.Transform.transform_rich_text(block.heading_1.rich_text)]
  end
}

{:ok, html} = BonsaiBlocks.blocks_to_html(blocks, mapping_functions)
```
"""
```

Update existing documentation and add new examples throughout the codebase.
```

## Prompt 17: Error Handling Enhancements

This prompt focuses on improving error handling throughout the library.

```text
Enhance error handling throughout the BonsaiBlocks library to ensure it's robust and user-friendly. Standardize error types and improve error messages.

Implement the following:

1. Create a consistent error handling strategy:
   - Define standard error types
   - Use consistent error tuples
   - Add context to errors

2. Improve API error handling:
   - Categorize Notion API errors
   - Provide meaningful error messages
   - Include relevant context (e.g., block ID, request details)

3. Improve transformation error handling:
   - Handle unknown block types gracefully
   - Provide context for malformed blocks
   - Allow partial success with warnings

4. Add detailed debug logging:
   - Log API requests and responses
   - Log transformation steps
   - Log configuration and options

5. Create helper functions for common error handling:
   - Format error messages
   - Wrap errors with context
   - Handle specific error cases

Make sure the error handling is consistent across all modules and provides useful information for debugging and troubleshooting.

Here's a sketch of some functionality to implement:

```elixir
defmodule BonsaiBlocks.Error do
  @moduledoc """
  Error handling utilities for BonsaiBlocks
  """

  def wrap_error({:error, reason}, context) do
    {:error, %{reason: reason, context: context}}
  end

  def format_error({:error, %{reason: reason, context: context}}) do
    # Format error message with context
  end

  # Add specific error handling functions
end
```

Integrate these error handling improvements throughout the codebase.
```

## Prompt 18: Integration Testing

This prompt focuses on creating comprehensive integration tests.

```text
Create comprehensive integration tests for the BonsaiBlocks library to ensure all components work together correctly. These tests should verify the end-to-end functionality of the library.

Implement the following:

1. Create a test module for integration tests:
   - test/integration/bonsai_blocks_test.exs

2. Set up test fixtures:
   - Sample Notion API responses for various block types
   - Expected HTML output for each block type
   - Composite examples with multiple block types

3. Implement tests for the main public functions:
   - fetch_blocks/2
   - blocks_to_html/2
   - page_to_html/3

4. Test various scenarios:
   - Success cases with different block types
   - Error cases and error handling
   - Custom mappings and configurations
   - Pagination and recursive fetching

5. Use mocks for the Notion API to avoid making actual API calls

Make sure the tests are comprehensive and verify that all components of the library work together correctly.

Here's a sketch of what to implement:

```elixir
defmodule BonsaiBlocks.IntegrationTest do
  use ExUnit.Case

  # Setup mocks and fixtures

  describe "page_to_html/3" do
    test "converts a page with various block types to HTML" do
      # Mock API responses
      # Call the function
      # Verify the HTML output
    end

    test "handles errors gracefully" do
      # Mock API errors
      # Call the function
      # Verify error handling
    end

    # More tests...
  end

  # More describe blocks for other functions...
end
```

Make sure the tests cover all key functionality and edge cases.
```

## Prompt 19: README and Documentation Completion

This prompt focuses on completing the README and documentation.

```text
Complete the README.md file and final documentation for the BonsaiBlocks library. This should provide comprehensive information for users of the library.

The README should include:

1. Project overview and purpose
   - Brief description of what BonsaiBlocks does
   - Key features and capabilities

2. Installation instructions
   - How to add to mix.exs
   - Any configuration requirements

3. Usage examples
   - Basic usage with default options
   - Custom mapping examples
   - Configuration examples

4. API documentation
   - Brief overview of main functions
   - Links to full documentation

5. Configuration options
   - List of all configuration options
   - Default values and explanations

6. Customization guide
   - How to create custom block mappings
   - Examples of common customizations

7. Troubleshooting and FAQ
   - Common issues and solutions
   - Best practices

The final documentation should be comprehensive and follow Elixir documentation best practices. Make sure all public functions are properly documented with @doc, @moduledoc, and @spec.

Here's a sketch of the README structure:

```markdown
# BonsaiBlocks

An Elixir library for converting Notion blocks to HTML.

## Features

- Fetches blocks from Notion API
- Converts blocks to HTML
- Supports custom transformations
- Handles pagination and rate limiting

## Installation

Add to your mix.exs:

```elixir
def deps do
  [
    {:bonsai_blocks, "~> 0.1.0"}
  ]
end
```

## Usage

Basic usage:

```elixir
{:ok, html} = BonsaiBlocks.page_to_html(
  "page_id_here",
  [api_token: System.get_env("NOTION_API_TOKEN")]
)
```

See [documentation](https://hexdocs.pm/bonsai_blocks) for more examples.

## Configuration

...

## Custom Mappings

...

## Troubleshooting

...
```

Complete this README and ensure all documentation is finalized.
```

## Prompt 20: Refinement and Optimization

This prompt focuses on refining and optimizing the library.

```text
Review, refine, and optimize the BonsaiBlocks library to ensure it's high quality and performant. This should be the final pass before considering the library complete.

Implement the following refinements:

1. Code optimization:
   - Review for performance bottlenecks
   - Optimize recursive block fetching
   - Consider caching opportunities

2. Code quality improvements:
   - Review for consistency in style and patterns
   - Ensure proper error handling throughout
   - Check for edge cases and handle them

3. API refinements:
   - Ensure consistent function signatures
   - Check for any missing functionality
   - Validate configuration options

4. Documentation refinements:
   - Ensure all public functions are documented
   - Check for clarity and completeness
   - Add examples where helpful

5. Testing improvements:
   - Ensure comprehensive test coverage
   - Check for edge cases in tests
   - Verify integration tests are complete

Make these refinements throughout the codebase, focusing on making the library robust, performant, and user-friendly.

Here's a sketch of what to implement:

```elixir
# Performance optimization example
def transform_blocks(blocks, custom_mappings \\ %{}) do
  # Optimize by pre-computing merged mappings
  mappings = Map.merge(default_mappings(), custom_mappings)

  # Process blocks efficiently
  Enum.map(blocks, fn block ->
    transform_block(block, mappings)
  end)
end

# Add missing functionality
def extract_block_id(block) do
  # Helper to extract block ID
end

# Improve error handling
def safe_transform(block, mappings) do
  # Safely transform with better error handling
end
```

Make similar refinements throughout the codebase.
```

## Conclusion

This prompt plan provides a structured approach to implementing the Bonsai-Blocks Elixir library step by step. Each prompt builds on the previous ones, ensuring incremental progress and proper integration of all components.

By following these prompts in sequence, a code-generation LLM should be able to create a complete, well-structured library that meets all the requirements specified in the project specification.

The implementation follows Elixir best practices, focusing on:
- Clear module boundaries and responsibilities
- Proper error handling
- Comprehensive documentation
- Thorough testing
- Incremental complexity

Each step is designed to be manageable while still moving the project forward meaningfully, resulting in a robust and maintainable library.
