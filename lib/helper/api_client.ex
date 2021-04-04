defmodule Sweatercli.ApiClient do
  import Sweatercli.Output

  defp call_api(city, state, country) do
    api_key = "a33edafecb11d20b0dbf0e19a7d0e082"

    api_uri =
      "api.openweathermap.org/data/2.5/weather?units=imperial&q=#{city},#{state},#{country}&appid=#{
        api_key
      }"

    response = HTTPoison.get!(api_uri)
    Poison.decode!(response.body)
  end

  def forecast(configFile, location) do
    [city, state, country] = String.split(location, "/")
    resp = call_api(city, state, country)

    %{"cod" => cod} = resp

    if cod == 200 do
      %{
        "main" => %{"feels_like" => feels_like},
        "weather" => allWeathers
      } = resp

      weather =
        allWeathers
        |> Enum.map(&"#{&1["main"]}")
        |> Enum.join(", ")

      suggest_clothing(configFile, feels_like, weather)
    else
      error("ERR: open weather returned a error.")
      IO.inspect(resp, label: "result")
      System.halt(1)
    end
  end

  defp suggest_clothing(configFile, feels_like, weather) do
    if not File.exists?(configFile) do
      error("ERR: Trying to use '#{configFile}' configuration file, but it does not exists.")
      System.halt(1)
    else
      case File.read(configFile) do
        {:ok, body} ->
          case Poison.decode!(body, as: %{}) do
            %{"recommendations" => config} ->
              print_results(configFile, config, feels_like, weather)

            _ ->
              error("ERR: Invalid configuration file '#{configFile}'.")
              info("")
              info("")
              warn("FILE EXAMPLE:")
              info("")
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
              System.halt(1)
          end

        {:error, :enoent} ->
          error("ERR: error trying to read configuration file '#{configFile}'.")
          System.halt(1)
      end
    end
  end

  defp print_results(configFile, config, feels_like, weather) do
    recomendations =
      Enum.filter(config, fn x ->
        feels_like >= x["min_temp"] && feels_like <= x["max_temp"]
      end)

    info("")
    warn("Weather for your Location:")
    info("\tFells Like: #{feels_like} F (#{weather})")
    info("")
    warn("We recomend bringing with you:")

    if recomendations == [] do
      info(
        "\tYou have no recomendations. (Check the fields: min_temp and max_temp in your config File: #{
          configFile
        })"
      )
    else
      Enum.each(recomendations, fn %{"name" => name} -> info("\t* #{name};") end)
    end

    info("")

    infonoreturn("S2 Scriptdrop - ")
    fun("Making Prescriptions Accessible")
    info("")
    debug("Have a great day ! Drive safe.")
    info("")
  end
end
