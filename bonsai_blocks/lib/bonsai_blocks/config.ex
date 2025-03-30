defmodule BonsaiBlocks.Config do
  @moduledoc """
  Configuration handling for BonsaiBlocks.

  This module provides functions to access and validate configuration options
  for the BonsaiBlocks library, including Notion API settings and rate limiting.

  ## Configuration Options

  * `:api_token` - Required. The Notion API token for authentication.
  * `:rate_limit_requests_per_second` - Optional. Default: 3.
  * `:max_retries` - Optional. Default: 5.
  * `:backoff_initial_delay` - Optional. Default: 1000 ms.
  * `:backoff_max_delay` - Optional. Default: 30000 ms.
  * `:timeout` - Optional. Default: 30000 ms.

  ## Usage

  Configuration can be set in your `config.exs` file:

      config :bonsai_blocks,
        api_token: System.get_env("NOTION_API_TOKEN"),
        rate_limit_requests_per_second: 5

  Or passed directly to functions that accept options:

      BonsaiBlocks.fetch_blocks(page_id, api_token: "secret_token")
  """

  @type config_option ::
          {:api_token, String.t()}
          | {:rate_limit_requests_per_second, pos_integer()}
          | {:max_retries, non_neg_integer()}
          | {:backoff_initial_delay, pos_integer()}
          | {:backoff_max_delay, pos_integer()}
          | {:timeout, pos_integer()}

  @type config :: %{
          optional(:api_token) => String.t(),
          optional(:rate_limit_requests_per_second) => pos_integer(),
          optional(:max_retries) => non_neg_integer(),
          optional(:backoff_initial_delay) => pos_integer(),
          optional(:backoff_max_delay) => pos_integer(),
          optional(:timeout) => pos_integer()
        }

  @type validation_result :: :ok | {:error, String.t()}

  @default_config %{
    rate_limit_requests_per_second: 3,
    max_retries: 5,
    backoff_initial_delay: 1000,
    backoff_max_delay: 30000,
    timeout: 30000
  }

  @doc """
  Returns the configuration for BonsaiBlocks.

  Merges the default configuration with any application configuration.

  ## Examples

      iex> BonsaiBlocks.Config.get()
      %{
        api_token: "secret_token",
        rate_limit_requests_per_second: 3,
        max_retries: 5,
        backoff_initial_delay: 1000,
        backoff_max_delay: 30000,
        timeout: 30000
      }
  """
  @spec get() :: config()
  def get do
    application_config = Application.get_all_env(:bonsai_blocks)
    Map.merge(@default_config, Enum.into(application_config, %{}))
  end

  @doc """
  Returns a specific configuration value.

  ## Parameters

  * `key` - The configuration key to retrieve.

  ## Examples

      iex> BonsaiBlocks.Config.get(:api_token)
      "secret_token"

      iex> BonsaiBlocks.Config.get(:rate_limit_requests_per_second)
      3
  """
  @spec get(atom()) :: any()
  def get(key) do
    get()[key]
  end

  @doc """
  Merges provided options with default configuration.

  ## Parameters

  * `options` - A keyword list of configuration options.

  ## Examples

      iex> BonsaiBlocks.Config.merge_options(api_token: "my_token", timeout: 60000)
      %{
        api_token: "my_token",
        rate_limit_requests_per_second: 3,
        max_retries: 5,
        backoff_initial_delay: 1000,
        backoff_max_delay: 30000,
        timeout: 60000
      }
  """
  @spec merge_options(keyword()) :: config()
  def merge_options(options) when is_list(options) do
    options_map = Enum.into(options, %{})
    Map.merge(@default_config, options_map)
  end

  @doc """
  Validates options to ensure required values are present and valid.

  ## Parameters

  * `options` - A map of configuration options.

  ## Returns

  * `:ok` - If the options are valid.
  * `{:error, reason}` - If the options are invalid.

  ## Examples

      iex> BonsaiBlocks.Config.validate_options(%{api_token: "secret_token"})
      :ok

      iex> BonsaiBlocks.Config.validate_options(%{})
      {:error, "Missing required option: api_token"}

      iex> BonsaiBlocks.Config.validate_options(%{api_token: ""})
      {:error, "Invalid api_token: cannot be empty"}
  """
  @spec validate_options(config()) :: validation_result()
  def validate_options(options) when is_map(options) do
    cond do
      is_nil(options[:api_token]) ->
        {:error, "Missing required option: api_token"}

      options[:api_token] == "" ->
        {:error, "Invalid api_token: cannot be empty"}

      not is_binary(options[:api_token]) ->
        {:error, "Invalid api_token: must be a string"}

      true ->
        :ok
    end
  end

  @doc """
  Validates the application configuration.

  Ensures that required configuration values are present and valid.

  ## Returns

  * `:ok` - If the configuration is valid.
  * `{:error, reason}` - If the configuration is invalid.

  ## Examples

      iex> BonsaiBlocks.Config.validate()
      :ok

      iex> BonsaiBlocks.Config.validate()
      {:error, "Missing required configuration: api_token"}
  """
  @spec validate() :: validation_result()
  def validate do
    config = get()
    validate_options(config)
  end
end
