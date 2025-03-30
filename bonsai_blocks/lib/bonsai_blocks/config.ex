defmodule BonsaiBlocks.Config do
  @moduledoc """
  Configuration handling for BonsaiBlocks.

  This module provides functions to access and validate configuration options
  for the BonsaiBlocks library, including Notion API settings and rate limiting.
  """

  @default_config %{
    rate_limit_requests_per_second: 3,
    max_retries: 5,
    backoff_initial_delay: 1000,
    backoff_max_delay: 30000,
    timeout: 30000
  }

  @doc """
  Returns the configuration for BonsaiBlocks.

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
  def get do
    application_config = Application.get_all_env(:bonsai_blocks)
    Map.merge(@default_config, Enum.into(application_config, %{}))
  end

  @doc """
  Returns a specific configuration value.

  ## Examples

      iex> BonsaiBlocks.Config.get(:api_token)
      "secret_token"

      iex> BonsaiBlocks.Config.get(:rate_limit_requests_per_second)
      3
  """
  def get(key) do
    get()[key]
  end

  @doc """
  Merges provided options with default configuration.

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
  def merge_options(options) when is_list(options) do
    options_map = Enum.into(options, %{})
    Map.merge(@default_config, options_map)
  end

  @doc """
  Validates the configuration.

  Ensures that required configuration values are present and valid.

  ## Examples

      iex> BonsaiBlocks.Config.validate()
      :ok

      iex> BonsaiBlocks.Config.validate()
      {:error, "Missing required configuration: api_token"}
  """
  def validate do
    config = get()

    cond do
      is_nil(config[:api_token]) ->
        {:error, "Missing required configuration: api_token"}

      true ->
        :ok
    end
  end
end
