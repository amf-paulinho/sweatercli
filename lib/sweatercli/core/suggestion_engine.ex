defmodule Sweatercli.SuggestionEngine do
  import Sweatercli.Output

  def start(openWeatheBehavior, jsonConfig, location) do
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

      find_clothing_suggestions(jsonConfig, feels_like, weather)
    else
      {:error, resp}
    end
  end

  def find_clothing_suggestions(jsonConfig, feels_like, weather) do
    suggestions =
      Enum.filter(jsonConfig, fn x ->
        feels_like >= x["min_temp"] && feels_like <= x["max_temp"]
      end)

    print_results(
      suggestions,
      feels_like,
      weather
    )

    {:ok, suggestions}
  end

  def print_results(recomendations, feels_like, weather) do
    info("")
    warn("Weather for your Location:")
    info("\tFells Like: #{feels_like} F (#{weather})")
    info("")
    warn("We recomend bringing with you:")

    if recomendations == [] do
      info(
        "\tYou have no recomendations. (Check the fields: min_temp and max_temp in your config File)"
      )
    else
      Enum.each(recomendations, fn %{"name" => name} ->
        info("\t* #{name};")
      end)
    end

    info("")

    infonoreturn("S2 Scriptdrop - ")
    fun("Making Prescriptions Accessible")
    info("")
    debug("Have a great day ! Drive safe.")
    info("")
  end
end
