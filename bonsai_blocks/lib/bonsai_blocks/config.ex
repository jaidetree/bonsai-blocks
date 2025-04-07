defmodule BonsaiBlocks.Config do
  @moduledoc """
  Configuration handling for BonsaiBlocks.

  This module provides functions to access and validate configuration options
  for the BonsaiBlocks library, including Notion API settings and rate limiting.

  ## Configuration Options

  * `:api_token` - Required. The Notion API token for authentication.
  * `:rate_limit_requests_per_second` - Optional. Default: 3.
  * `:max_retries` - Optional. Default: 5.
  * `:backoff_initial_delay` - Optional. Default: 5000 ms.
  * `:backoff_max_delay` - Optional. Default: 120000 ms (2 min).
  * `:timeout` - Optional. Default: 30000 ms.

  ## Usage

  Configuration can be set in your `config.exs` file:

      config :bonsai_blocks,
        api_token: System.get_env("NOTION_API_TOKEN"),
        rate_limit_requests_per_second: 5

  Or passed directly to functions that accept options:

      BonsaiBlocks.fetch_blocks(page_id, api_token: "secret_token")
  """

  @type config :: %{
          :api_token => String.t(),
          optional(:rate_limit_requests_per_second) => pos_integer(),
          optional(:max_retries) => non_neg_integer(),
          optional(:backoff_initial_delay) => pos_integer(),
          optional(:backoff_max_delay) => pos_integer(),
          optional(:timeout) => pos_integer()
        }

  @type validation_result :: {:ok, config()} | {:error, String.t()}

  @default_config %{
    rate_limit_requests_per_second: 3,
    max_retries: 5,
    backoff_initial_delay: 5000,
    backoff_max_delay: 120_000,
    timeout: 30000
  }

  @doc """
  Creates a configuration map by merging provided options with defaults.

  ## Parameters

  * `options` - A map of configuration options or keyword list.

  ## Returns

  * `{:ok, config}` - If the configuration is valid.
  * `{:error, reason}` - If the configuration is invalid.

  ## Examples

      iex> BonsaiBlocks.Config.create([api_token: "custom_token", timeout: 45000])
      {:ok, %{
        api_token: "my_token",
        rate_limit_requests_per_second: 3,
        max_retries: 5,
        backoff_initial_delay: 5000,
        backoff_max_delay: 120_000,
        timeout: 60000
      }}
  """
  @spec create(keyword()) :: validation_result()
  def create(options) when is_list(options) do
    options |> Enum.into(%{}) |> Map.merge(@default_config) |> validate()
  end

  @doc """
  Creates a configuration map and raises an error if invalid.

  ## Parameters

  * `options` - A keyword list of configuration options.

  ## Returns

  * The validated configuration map.

  ## Raises

  * `ArgumentError` - If the configuration is invalid.

  ## Examples

      iex> BonsaiBlocks.Config.create!(api_token: "my_token")
      %{
        api_token: "my_token",
        rate_limit_requests_per_second: 3,
        max_retries: 5,
        backoff_initial_delay: 5000,
        backoff_max_delay: 120_000,
        timeout: 30000
      }
  """
  @spec create!(keyword()) :: config()
  def create!(options \\ []) when is_list(options) do
    config = options |> Enum.into(%{}) |> Map.merge(@default_config)
    IO.inspect(config)
    result = config |> validate()

    case result do
      {:ok, config} -> config
      {:error, reason} -> raise ArgumentError, reason
    end
  end

  @doc """
  Validates a configuration map.

  Checks that required options are present and have valid values.

  ## Parameters

  * `options` - A map of configuration options.

  ## Returns

  * `{:ok, config}` - If the configuration is valid.
  * `{:error, reason}` - If the configuration is invalid.

  ## Examples

      iex> BonsaiBlocks.Config.validate(%{api_token: "valid_token"})
      {:ok, %{api_token: "valid_token"}}

      iex> BonsaiBlocks.Config.validate(%{})
      {:error, "Missing required option: api_token"}
  """
  @spec validate(config()) :: validation_result()
  def validate(options) when is_map(options) do
    cond do
      is_nil(options.api_token) ->
        {:error, "Missing required option: api_token"}

      options.api_token == "" ->
        {:error, "Invalid api_token: cannot be empty"}

      not is_binary(options.api_token) ->
        {:error, "Invalid api_token: must be a string"}

      true ->
        {:ok, options}
    end
  end
end
