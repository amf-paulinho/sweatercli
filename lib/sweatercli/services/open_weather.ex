defmodule Sweatercli.OpenWeatherBehavior do
  @callback call_api(city :: any, state :: any, country :: any) :: any
end

defmodule Sweatercli.OpenWeather do
  @behaviour Sweatercli.OpenWeatherBehavior
  import Sweatercli.AppConstants

  @impl true
  def call_api(city, state, country) do
    api_uri =
      "api.openweathermap.org/data/2.5/weather?units=imperial&q=#{city},#{state},#{country}&appid=#{
        api_key()
      }"

    response = HTTPoison.get!(api_uri)
    Poison.decode!(response.body)
  end
end
