defmodule SweatercliTest do
  use ExUnit.Case

  defmodule SweatercliTest.OpenWeatherMock do
    @behaviour Sweatercli.OpenWeatherBehavior

    @impl true
    def call_api(_city, _state, _country) do
      %{
        "base" => "stations",
        "clouds" => %{"all" => 90},
        "cod" => 200,
        "coord" => %{"lat" => 58.3019, "lon" => -134.4197},
        "dt" => 1_617_607_965,
        "id" => 5_554_072,
        "main" => %{
          "feels_like" => 26.28,
          "humidity" => 81,
          "pressure" => 1021,
          "temp" => 33.73,
          "temp_max" => 39.2,
          "temp_min" => 28.99
        },
        "name" => "Juneau",
        "snow" => %{"1h" => 0.25},
        "sys" => %{
          "country" => "US",
          "id" => 7729,
          "sunrise" => 1_617_545_715,
          "sunset" => 1_617_594_325,
          "type" => 1
        },
        "timezone" => -28800,
        "visibility" => 10000,
        "weather" => [
          %{
            "description" => "light snow",
            "icon" => "13n",
            "id" => 600,
            "main" => "Snow"
          }
        ],
        "wind" => %{"deg" => 100, "speed" => 9.22}
      }
    end
  end

  defmodule SweatercliTest.FailOpenWeatherMock do
    @behaviour Sweatercli.OpenWeatherBehavior

    @impl true
    def call_api(_city, _state, _country) do
      %{"cod" => "404", "message" => "city not found"}
    end
  end

  defmodule SweatercliTest.BadConfigurationFileMock do
    @behaviour Sweatercli.ConfigurationFileBehavior
    import Sweatercli.Output

    @impl true
    def get_config_json(_configFile) do
      body = "{\"recommezsandations\":[
          {
            \"name\": \"Sunglasses\",
            \"waterproof\": false,
            \"min_temp\": 75,
            \"max_temp\": 100
          },
          {
            \"name\": \"Rain Jacket\",
            \"waterproof\": true,
            \"min_temp\": 62,
            \"max_temp\": 80
          },
          {
            \"name\": \"Sweater\",
            \"waterproof\": false,
            \"min_temp\": 50,
            \"max_temp\": 68
          },
          {
            \"name\": \"Light Coat\",
            \"waterproof\": true,
            \"min_temp\": 35,
            \"max_temp\": 55
          },
          {
            \"name\": \"Heavy Coat\",
            \"waterproof\": true,
            \"min_temp\": 0,
            \"max_temp\": 40
          },
          {
            \"name\": \"Comfortable Shoes\",
            \"waterproof\": false,
            \"min_temp\": 25,
            \"max_temp\": 90
          },
          {
            \"name\": \"Snow Boots\",
            \"waterproof\": true,
            \"min_temp\": 0,
            \"max_temp\": 35
          }
        ]}"

      case Poison.decode!(body, as: %{}) do
        %{"recommendations" => jsonConfig} ->
          {:ok, jsonConfig}

        _ ->
          {:error, :invalid_config_file}
      end
    end

    @impl true
    def print_invalid_config_file_help(configFile) do
      error("ERR: Invalid configuration file '#{configFile}'.")
      info("")
      warn("FILE EXAMPLE:")
      info("----------------------------[BEGIN]--")
      debug("{")
      debug("\t\"recommendations\": [")
      debug("\t{")
      debug("\t\t\"name\": \"Sunglasses\",")
      debug("\t\t\"waterproof\": false,")
      debug("\t\t\"min_temp\": 75,")
      debug("\t\t\"max_temp\": 100")
      debug("\t},")
      debug("\t{")
      debug("\t\t\"name\": \"Rain Jacket\",")
      debug("\t\t\"waterproof\": true,")
      debug("\t\t\"min_temp\": 62,")
      debug("\t\t\"max_temp\": 80")
      debug("\t}]")
      debug("}")
      info("------------------------------[END]--")
      info("")

      :ok
    end
  end

  defmodule SweatercliTest.GoodConfigurationFileMock do
    @behaviour Sweatercli.ConfigurationFileBehavior
    import Sweatercli.Output

    @impl true
    def get_config_json(_configFile) do
      body = "{\"recommendations\":[
          {
            \"name\": \"Sunglasses\",
            \"waterproof\": false,
            \"min_temp\": 75,
            \"max_temp\": 100
          },
          {
            \"name\": \"Rain Jacket\",
            \"waterproof\": true,
            \"min_temp\": 62,
            \"max_temp\": 80
          },
          {
            \"name\": \"Sweater\",
            \"waterproof\": false,
            \"min_temp\": 50,
            \"max_temp\": 68
          },
          {
            \"name\": \"Light Coat\",
            \"waterproof\": true,
            \"min_temp\": 35,
            \"max_temp\": 55
          },
          {
            \"name\": \"Heavy Coat\",
            \"waterproof\": true,
            \"min_temp\": 0,
            \"max_temp\": 40
          },
          {
            \"name\": \"Comfortable Shoes\",
            \"waterproof\": false,
            \"min_temp\": 25,
            \"max_temp\": 90
          },
          {
            \"name\": \"Snow Boots\",
            \"waterproof\": true,
            \"min_temp\": 0,
            \"max_temp\": 35
          }
        ]}"

      case Poison.decode!(body, as: %{}) do
        %{"recommendations" => jsonConfig} ->
          {:ok, jsonConfig}

        _ ->
          {:error, :invalid_config_file}
      end
    end

    @impl true
    def print_invalid_config_file_help(configFile) do
      error("ERR: Invalid configuration file '#{configFile}'.")
      info("")
      warn("FILE EXAMPLE:")
      info("----------------------------[BEGIN]--")
      debug("{")
      debug("\t\"recommendations\": [")
      debug("\t{")
      debug("\t\t\"name\": \"Sunglasses\",")
      debug("\t\t\"waterproof\": false,")
      debug("\t\t\"min_temp\": 75,")
      debug("\t\t\"max_temp\": 100")
      debug("\t},")
      debug("\t{")
      debug("\t\t\"name\": \"Rain Jacket\",")
      debug("\t\t\"waterproof\": true,")
      debug("\t\t\"min_temp\": 62,")
      debug("\t\t\"max_temp\": 80")
      debug("\t}]")
      debug("}")
      info("------------------------------[END]--")
      info("")

      :ok
    end
  end

  test "01 - test CLI main process - Yellow Brick Path" do
    assert Sweatercli.CLI.process_args(
             {[file: "", location: "Juneau/AK/US"], [], []},
             SweatercliTest.GoodConfigurationFileMock,
             SweatercliTest.OpenWeatherMock
           ) == Sweatercli.AppConstants.exit_success()
  end

  test "02 - test CLI main process using Bad Config File" do
    assert Sweatercli.CLI.process_args(
             {[file: "", location: "Juneau/AK/US"], [], []},
             SweatercliTest.BadConfigurationFileMock,
             SweatercliTest.OpenWeatherMock
           ) == Sweatercli.AppConstants.exit_error_invalid_config_file()
  end

  test "03 - test CLI main process open weather fail (Cod != 200)" do
    assert Sweatercli.CLI.process_args(
             {[file: "", location: "GhostCityXPT/XX/ZZ"], [], []},
             SweatercliTest.GoodConfigurationFileMock,
             SweatercliTest.FailOpenWeatherMock
           ) == Sweatercli.AppConstants.exit_error_open_weather_fail()
  end

  test "04 - test CLI main process using Wrong Options Combination" do
    assert Sweatercli.CLI.process_args(
             {[file: "", location: "Juneau/AK/US", help: true], [], []},
             SweatercliTest.GoodConfigurationFileMock,
             SweatercliTest.OpenWeatherMock
           ) == Sweatercli.AppConstants.exit_error_wrong_options_combination()
  end

  test "05 - test CLI main process using Invalid Options" do
    assert Sweatercli.CLI.process_args(
             {[], [], [unknowoption: "random"]},
             SweatercliTest.GoodConfigurationFileMock,
             SweatercliTest.OpenWeatherMock
           ) == Sweatercli.AppConstants.exit_error_invalid_options()
  end

  test "99 - test Core Engine Logic in some scenarios" do
    #todo: Create 2 or 3 tests matching results against data informed
    assert true;
  end




end
