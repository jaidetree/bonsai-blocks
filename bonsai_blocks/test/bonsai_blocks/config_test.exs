defmodule BonsaiBlocks.ConfigTest do
  use ExUnit.Case, async: true
  alias BonsaiBlocks.Config

  describe "get/0" do
    test "returns default configuration when no application config is set" do
      # Reset application environment for testing
      Application.delete_env(:bonsai_blocks, :api_token)
      
      config = Config.get()
      assert config[:rate_limit_requests_per_second] == 3
      assert config[:max_retries] == 5
      assert config[:backoff_initial_delay] == 5000
      assert config[:backoff_max_delay] == 120_000
      assert config[:timeout] == 30000
      assert is_nil(config[:api_token])
    end

    test "merges application config with defaults" do
      # Set test application environment
      Application.put_env(:bonsai_blocks, :api_token, "test_token")
      Application.put_env(:bonsai_blocks, :timeout, 60000)
      
      config = Config.get()
      assert config[:api_token] == "test_token"
      assert config[:timeout] == 60000
      assert config[:rate_limit_requests_per_second] == 3 # Default value
      
      # Clean up
      Application.delete_env(:bonsai_blocks, :api_token)
      Application.delete_env(:bonsai_blocks, :timeout)
    end
  end

  describe "get/1" do
    test "returns specific configuration value" do
      Application.put_env(:bonsai_blocks, :api_token, "specific_token")
      
      assert Config.get(:api_token) == "specific_token"
      assert Config.get(:rate_limit_requests_per_second) == 3
      assert is_nil(Config.get(:non_existent_key))
      
      # Clean up
      Application.delete_env(:bonsai_blocks, :api_token)
    end
  end

  describe "merge_options/1" do
    test "merges provided options with defaults" do
      options = [api_token: "custom_token", timeout: 45000]
      config = Config.merge_options(options)
      
      assert config[:api_token] == "custom_token"
      assert config[:timeout] == 45000
      assert config[:rate_limit_requests_per_second] == 3
      assert config[:max_retries] == 5
    end

    test "custom options override defaults" do
      options = [rate_limit_requests_per_second: 10, max_retries: 8]
      config = Config.merge_options(options)
      
      assert config[:rate_limit_requests_per_second] == 10
      assert config[:max_retries] == 8
      assert config[:backoff_initial_delay] == 5000 # Default value
    end
  end

  describe "validate_options/1" do
    test "returns :ok for valid options" do
      options = %{api_token: "valid_token"}
      assert Config.validate_options(options) == :ok
    end

    test "returns error when api_token is missing" do
      options = %{}
      assert Config.validate_options(options) == {:error, "Missing required option: api_token"}
    end

    test "returns error when api_token is empty" do
      options = %{api_token: ""}
      assert Config.validate_options(options) == {:error, "Invalid api_token: cannot be empty"}
    end

    test "returns error when api_token is not a string" do
      options = %{api_token: 123}
      assert Config.validate_options(options) == {:error, "Invalid api_token: must be a string"}
    end
  end

  describe "validate/0" do
    test "returns :ok when application config is valid" do
      Application.put_env(:bonsai_blocks, :api_token, "app_token")
      
      assert Config.validate() == :ok
      
      # Clean up
      Application.delete_env(:bonsai_blocks, :api_token)
    end

    test "returns error when application config is invalid" do
      # Ensure api_token is not set
      Application.delete_env(:bonsai_blocks, :api_token)
      
      assert Config.validate() == {:error, "Missing required option: api_token"}
    end
  end
end
