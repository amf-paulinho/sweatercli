defmodule Sweatercli.SuggestionEngine do
  import Sweatercli.Output

  def start(openWeatheBehavior, configFile, location) do
    [city, state, country] = String.split(location, "/")

    resp = openWeatheBehavior.call_api(city, state, country)

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

      :ok
    else
      error("ERR: open weather returned a error.")
      IO.inspect(resp, label: "result")
      :error
      System.halt(1)
    end
  end

  def suggest_clothing(configFile, feels_like, weather) do
    if not File.exists?(configFile) do
      error("ERR: Trying to use '#{configFile}' configuration file, but it does not exists.")
      :error_file_not_found
      System.halt(1)
    else
      case File.read(configFile) do
        {:ok, body} ->
          case Poison.decode!(body, as: %{}) do
            %{"recommendations" => config} ->
              print_results(
                configFile,
                Enum.filter(config, fn x ->
                  feels_like >= x["min_temp"] && feels_like <= x["max_temp"]
                end),
                feels_like,
                weather
              )

              :ok

            _ ->
              invalid_config_file(configFile)
              :error_invalid_config_file
          end

        {:error, :enoent} ->
          error("ERR: error trying to read configuration file '#{configFile}'.")
          :error_io_error
          System.halt(1)
      end
    end

    :ok
  end

  def print_results(configFile, recomendations, feels_like, weather) do
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

    :ok
  end

  defp invalid_config_file(configFile) do
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
end
