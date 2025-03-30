# Bonsai-Blocks: Project Task Checklist

This checklist covers the implementation of Bonsai-Blocks, an Elixir library for converting Notion blocks to HTML. Each section represents a logical iteration of work, broken down into specific actionable tasks.

## Iteration 1: Project Setup and Basic Structure

- [ ] Create new Elixir project 
  - [ ] Run `mix new bonsai_blocks --module BonsaiBlocks`
  - [ ] Initialize git repository
  - [ ] Make initial commit

- [ ] Configure dependencies in mix.exs
  - [ ] Add HTTP client (Req or HTTPoison)
  - [ ] Add JSON parser (Jason)
  - [ ] Add ExDoc for documentation
  - [ ] Add testing utilities (ExUnit comes built-in)

- [ ] Set up basic module structure
  - [ ] Create `lib/bonsai_blocks.ex` for main API
  - [ ] Create `lib/bonsai_blocks/api.ex` for Notion API communication
  - [ ] Create `lib/bonsai_blocks/config.ex` for configuration handling
  - [ ] Create `lib/bonsai_blocks/html.ex` for HTML generation
  - [ ] Create `lib/bonsai_blocks/transform.ex` for block transformations

- [ ] Write initial README
  - [ ] Project overview and purpose
  - [ ] Basic installation instructions
  - [ ] Simple usage example
  - [ ] License information

- [ ] Set up GitHub repository
  - [ ] Add .gitignore file for Elixir
  - [ ] Create initial project description
  - [ ] Push initial code

## Iteration 2: Notion API Authentication and Configuration

- [ ] Create configuration module
  - [ ] Implement default configuration options
  - [ ] Allow runtime configuration override
  - [ ] Add validation for required options

- [ ] Build authentication functionality
  - [ ] Implement Notion API token handling
  - [ ] Create authorization header generation
  - [ ] Add token validation

- [ ] Create HTTP client wrapper
  - [ ] Implement basic request function
  - [ ] Add proper headers for Notion API
  - [ ] Handle JSON serialization/deserialization

- [ ] Set up error handling
  - [ ] Define error types and structures
  - [ ] Implement error conversion from HTTP responses
  - [ ] Add context to error messages

- [ ] Write tests
  - [ ] Test configuration validation
  - [ ] Test authentication header generation
  - [ ] Test basic HTTP client with mocks

## Iteration 3: Basic Block Fetching

- [ ] Implement block fetching
  - [ ] Create function to fetch top-level blocks
  - [ ] Add block_id validation
  - [ ] Handle response parsing

- [ ] Parse Notion API response
  - [ ] Extract block data from response
  - [ ] Handle empty responses
  - [ ] Normalize block data structure

- [ ] Implement error handling
  - [ ] Handle HTTP errors
  - [ ] Handle Notion API errors
  - [ ] Add informative error messages

- [ ] Set up logging
  - [ ] Add debug logging for API requests
  - [ ] Add info logging for successful fetches
  - [ ] Add error logging for failures

- [ ] Write tests
  - [ ] Create fixture data from Notion API samples
  - [ ] Test block fetching with mocked responses
  - [ ] Test error handling scenarios

## Iteration 4: Simple HTML Transformation

- [ ] Define data structure format
  - [ ] Implement Hiccup-inspired format (`[tag, attributes, content]`)
  - [ ] Create helpers for generating format
  - [ ] Document the structure

- [ ] Implement HTML generation
  - [ ] Create function to convert data structure to HTML
  - [ ] Handle nested elements
  - [ ] Handle text content vs. element content

- [ ] Create basic block mappers
  - [ ] Implement mapper for paragraph blocks
  - [ ] Implement mapper for heading_1 blocks
  - [ ] Implement mapper for heading_2 blocks
  - [ ] Implement mapper for heading_3 blocks

- [ ] Implement block processing
  - [ ] Create function to process list of blocks
  - [ ] Handle unknown block types gracefully
  - [ ] Concatenate HTML from multiple blocks

- [ ] Write tests
  - [ ] Test HTML generation from hiccup format
  - [ ] Test block mappers
  - [ ] Test complete block processing flow

## Iteration 5: Initial API Integration

- [ ] Implement public API functions
  - [ ] Create `fetch_blocks/2` function
  - [ ] Create `blocks_to_html/2` function
  - [ ] Create `page_to_html/3` function

- [ ] Add default mappings
  - [ ] Create a default mapping for common block types
  - [ ] Allow override with custom mappings
  - [ ] Document mapping format

- [ ] Write integration tests
  - [ ] Test fetch_blocks with mocked API
  - [ ] Test blocks_to_html with sample blocks
  - [ ] Test page_to_html with mocked API and sample blocks

- [ ] Create usage examples
  - [ ] Add examples to documentation
  - [ ] Create example script in examples/ directory
  - [ ] Add example to README

- [ ] Review API design
  - [ ] Ensure consistent function signatures
  - [ ] Check error handling consistency
  - [ ] Review documentation clarity

## Iteration 6: Rich Text Handling

- [ ] Implement rich text parser
  - [ ] Create transform_rich_text helper function
  - [ ] Extract plain text content
  - [ ] Handle annotations

- [ ] Add annotation support
  - [ ] Implement bold text handling
  - [ ] Implement italic text handling
  - [ ] Implement underline text handling
  - [ ] Implement strikethrough text handling
  - [ ] Implement inline code handling

- [ ] Update mappers
  - [ ] Update paragraph mapper to use rich text
  - [ ] Update heading mappers to use rich text
  - [ ] Ensure proper nesting of annotations

- [ ] Handle links in rich text
  - [ ] Extract URL from rich text
  - [ ] Create anchor tags for links
  - [ ] Support link annotations

- [ ] Write tests
  - [ ] Test rich text transformation
  - [ ] Test each annotation type
  - [ ] Test combinations of annotations
  - [ ] Test links in rich text

## Iteration 7: Pagination Support

- [ ] Update API client for pagination
  - [ ] Add support for start_cursor parameter
  - [ ] Handle has_more flag in response
  - [ ] Extract next_cursor from response

- [ ] Implement pagination handler
  - [ ] Create function to fetch all pages
  - [ ] Implement cursor-based pagination
  - [ ] Aggregate results from multiple pages

- [ ] Add pagination configuration
  - [ ] Allow page size configuration
  - [ ] Add option to limit total pages
  - [ ] Configure timeout between pagination requests

- [ ] Update fetch_blocks function
  - [ ] Use pagination handler for complete results
  - [ ] Respect configured limits
  - [ ] Handle errors across pagination

- [ ] Write tests
  - [ ] Test pagination with mocked responses
  - [ ] Test limits and configuration
  - [ ] Test error cases during pagination

## Iteration 8: Recursive Block Fetching

- [ ] Detect blocks with children
  - [ ] Identify has_children flag in blocks
  - [ ] Extract block ID for child fetching
  - [ ] Handle blocks without children

- [ ] Implement recursive fetching
  - [ ] Create recursive function for child blocks
  - [ ] Set up depth tracking and limits
  - [ ] Aggregate parent and child blocks

- [ ] Update data structure
  - [ ] Add children field to block structure
  - [ ] Maintain block hierarchy
  - [ ] Ensure IDs are preserved

- [ ] Update HTML generation
  - [ ] Process nested block structures
  - [ ] Generate nested HTML elements
  - [ ] Handle special parent-child relationships

- [ ] Write tests
  - [ ] Test detection of blocks with children
  - [ ] Test recursive fetching with mocks
  - [ ] Test HTML generation for nested blocks
  - [ ] Test depth limits and edge cases

## Iteration 9: Rate Limiting and Exponential Backoff

- [ ] Implement rate limiter
  - [ ] Create token bucket algorithm
  - [ ] Configure requests per second
  - [ ] Add delay mechanism for rate control

- [ ] Implement exponential backoff
  - [ ] Create retry mechanism for failed requests
  - [ ] Implement increasing delay between retries
  - [ ] Configure maximum retry attempts

- [ ] Add configuration options
  - [ ] Add rate_limit_requests_per_second option
  - [ ] Add max_retries option
  - [ ] Add backoff_initial_delay option
  - [ ] Add backoff_max_delay option

- [ ] Integrate with API client
  - [ ] Apply rate limiting to all requests
  - [ ] Add retry logic with backoff
  - [ ] Add logging for rate limits and retries

- [ ] Write tests
  - [ ] Test rate limiting behavior
  - [ ] Test exponential backoff calculation
  - [ ] Test retry logic with mocked failures

## Iteration 10: List Block Types

- [ ] Add bulleted list support
  - [ ] Create mapper for bulleted_list_item blocks
  - [ ] Handle list item content
  - [ ] Group consecutive list items

- [ ] Add numbered list support
  - [ ] Create mapper for numbered_list_item blocks
  - [ ] Handle list item content
  - [ ] Maintain proper numbering

- [ ] Implement list grouping
  - [ ] Detect consecutive list items
  - [ ] Group same-type items into a single list
  - [ ] Handle mixed list types

- [ ] Update HTML generation
  - [ ] Generate ul/li tags for bulleted lists
  - [ ] Generate ol/li tags for numbered lists
  - [ ] Support nested lists

- [ ] Write tests
  - [ ] Test bulleted list mapping
  - [ ] Test numbered list mapping
  - [ ] Test list grouping
  - [ ] Test nested lists

## Iteration 11: Code Blocks and Horizontal Rules

- [ ] Implement code block support
  - [ ] Create mapper for code blocks
  - [ ] Extract code content and language
  - [ ] Generate pre/code tags with language class

- [ ] Add syntax highlighting options
  - [ ] Add option for syntax highlighting
  - [ ] Implement CSS class for highlighting
  - [ ] Document CSS requirements

- [ ] Implement horizontal rule support
  - [ ] Create mapper for divider blocks
  - [ ] Generate hr tag
  - [ ] Handle horizontal rule attributes

- [ ] Update HTML generation
  - [ ] Integrate code block handling
  - [ ] Integrate horizontal rule handling
  - [ ] Handle empty code blocks

- [ ] Write tests
  - [ ] Test code block mapping
  - [ ] Test language handling
  - [ ] Test horizontal rule mapping

## Iteration 12: Media Blocks (Images and Files)

- [ ] Implement image block support
  - [ ] Create mapper for image blocks
  - [ ] Extract image URL and caption
  - [ ] Generate img tag with alt text

- [ ] Add file handling
  - [ ] Create mapper for file blocks
  - [ ] Extract file URL and name
  - [ ] Generate appropriate link tag

- [ ] Implement PDF embedding
  - [ ] Create mapper for PDF blocks
  - [ ] Generate embed or object tag
  - [ ] Add fallback content

- [ ] Handle external vs. internal media
  - [ ] Detect Notion hosted vs. external media
  - [ ] Handle different URL formats
  - [ ] Implement URL validation

- [ ] Write tests
  - [ ] Test image block mapping
  - [ ] Test file block mapping
  - [ ] Test PDF embedding
  - [ ] Test URL handling

## Iteration 13: Custom Mapping Functions

- [ ] Enhance mapping system
  - [ ] Support custom mapping functions
  - [ ] Create fallback mechanism
  - [ ] Add helper functions for mappers

- [ ] Implement mapping customization
  - [ ] Allow passing custom mapping functions
  - [ ] Merge with default mappings
  - [ ] Handle unknown block types

- [ ] Create example custom mappings
  - [ ] Add custom class to headings
  - [ ] Create custom wrapper for paragraphs
  - [ ] Implement custom image handling

- [ ] Update documentation
  - [ ] Document mapping format
  - [ ] Provide examples for custom mappings
  - [ ] Explain mapper function requirements

- [ ] Write tests
  - [ ] Test custom mapping functions
  - [ ] Test mapping overrides
  - [ ] Test fallback mechanism

## Iteration 14: Comprehensive Error Handling

- [ ] Review error handling
  - [ ] Identify all error cases
  - [ ] Standardize error return values
  - [ ] Improve error messages

- [ ] Categorize error types
  - [ ] Define error categories (API, parsing, mapping)
  - [ ] Create structured error types
  - [ ] Add context to errors

- [ ] Implement debugging helpers
  - [ ] Add detailed debug logging
  - [ ] Create helper for error diagnosis
  - [ ] Add troubleshooting section to docs

- [ ] Handle edge cases
  - [ ] Test with malformed blocks
  - [ ] Handle API rate limiting errors
  - [ ] Handle authentication failures

- [ ] Write tests
  - [ ] Test error handling for each category
  - [ ] Test edge cases
  - [ ] Validate error messages

## Iteration 15: Documentation and Polishing

- [ ] Write module documentation
  - [ ] Add @moduledoc to all modules
  - [ ] Document public functions with @doc
  - [ ] Add type specs with @spec
  - [ ] Add examples with @example

- [ ] Generate ExDoc documentation
  - [ ] Configure ExDoc options
  - [ ] Generate HTML documentation
  - [ ] Review generated docs for clarity

- [ ] Create comprehensive examples
  - [ ] Add example for basic usage
  - [ ] Add example for custom mapping
  - [ ] Add example for complete workflow

- [ ] Review API consistency
  - [ ] Ensure consistent function signatures
  - [ ] Validate option naming conventions
  - [ ] Check for any breaking changes

- [ ] Final testing
  - [ ] Run complete test suite
  - [ ] Test with actual Notion page
  - [ ] Benchmark performance
  - [ ] Check code coverage

## Additional Tasks and Future Work

- [ ] Implement caching mechanism
  - [ ] Add cache for fetched blocks
  - [ ] Configure cache TTL
  - [ ] Add cache invalidation

- [ ] Support additional block types
  - [ ] Add support for tables
  - [ ] Add support for callouts
  - [ ] Add support for toggles
  - [ ] Add support for equations

- [ ] Additional output formats
  - [ ] Add Markdown output option
  - [ ] Add JSON output option
  - [ ] Consider XML/custom format options

- [ ] Database querying
  - [ ] Implement Notion database queries
  - [ ] Add filtering support
  - [ ] Support sorting and pagination

- [ ] Comments and discussions
  - [ ] Add support for Notion comments
  - [ ] Add support for discussions
  - [ ] Implement comment threading
