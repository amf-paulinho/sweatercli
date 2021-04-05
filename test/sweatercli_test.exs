defmodule SweatercliTest do
  use ExUnit.Case
  doctest Sweatercli

  test "greets the world" do
    assert Sweatercli.hello() == :IllBuildRestAPIThatsConsumeCLI
  end

  test "suggestion engine" do

    defmodule Sweatercli.OpenWeather do
      @behaviour Sweatercli.OpenWeatherBehavior

      @impl true
      def call_api(city, state, country) do
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


    



  end
end
