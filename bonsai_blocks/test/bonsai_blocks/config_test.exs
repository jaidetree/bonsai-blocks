defmodule BonsaiBlocks.ConfigTest do
  use ExUnit.Case, async: true
  alias BonsaiBlocks.Config

  describe "create/1" do
    test "merges provided map options with defaults" do
      options = %{api_token: "custom_token", timeout: 45000}
      {:ok, config} = Config.create(options)

      assert config.api_token == "custom_token"
      assert config.timeout == 45000
      assert config.rate_limit_requests_per_second == 3
      assert config.max_retries == 5
    end

    test "merges provided keyword options with defaults" do
      options = [api_token: "custom_token", timeout: 45000]
      {:ok, config} = Config.create(options)

      assert config.api_token == "custom_token"
      assert config.timeout == 45000
      assert config.rate_limit_requests_per_second == 3
      assert config.max_retries == 5
    end

    test "custom options override defaults" do
      options = [api_token: "custom_token", rate_limit_requests_per_second: 10, max_retries: 8]
      {:ok, config} = Config.create(options)

      assert config.rate_limit_requests_per_second == 10
      assert config.max_retries == 8
      # Default value
      assert config.backoff_initial_delay == 5000
    end
  end

  describe "create!/1" do
    test "returns config directly when valid" do
      options = %{api_token: "custom_token"}
      config = Config.create!(options)

      assert config.api_token == "custom_token"
      assert config.rate_limit_requests_per_second == 3
    end

    test "raises ArgumentError when invalid" do
      assert_raise ArgumentError, fn ->
        Config.create!(%{})
      end
    end
  end

  describe "validate/1" do
    test "returns {:ok, config} for valid options" do
      options = %{api_token: "valid_token"}
      assert Config.validate(options) == {:ok, options}
    end

    test "returns error when api_token is missing" do
      options = %{}
      assert Config.validate(options) == {:error, "Missing required option: api_token"}
    end

    test "returns error when api_token is empty" do
      options = %{api_token: ""}
      assert Config.validate(options) == {:error, "Invalid api_token: cannot be empty"}
    end

    test "returns error when api_token is not a string" do
      options = %{api_token: 123}
      assert Config.validate(options) == {:error, "Invalid api_token: must be a string"}
    end
  end
end
