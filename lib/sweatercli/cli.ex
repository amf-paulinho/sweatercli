defmodule Sweatercli.CLI do
  @moduledoc """
   (S)criptDrop (W)eather (E)valuation (A)nd (T)hermal (E)xcellence (R)ecommendations.
  """
  import Sweatercli.AppConstants
  import Sweatercli.Output

  def main(args) do
    Application.put_env(:elixir, :ansi_enabled, true)

    exitCode =
      args
      |> Enum.sort()
      |> parse_args
      |> process_args(Sweatercli.ConfigurationFile, Sweatercli.OpenWeather)

    if exitCode == exit_success(), do: System.stop(exitCode), else: System.halt(exitCode)
  end

  defp parse_args(args) do
    options = [
      strict: [help: :boolean, queryuser: :boolean, file: :string, location: :string],
      aliases: [h: :help, X: :queryuser, f: :file, l: :location]
    ]

    {opts, rest, invalid} = OptionParser.parse(args, options)

    # IO.inspect({opts, rest, invalid})

    {opts, rest, invalid}
  end

  def process_args({_opts, _params, [_ | _] = invalid}, _serviceConfig, _serviceOpenWeather) do
    error("ERR: Invalid Options !")
    IO.inspect(invalid, label: nil)

    exit_error_invalid_options()
  end

  def process_args({[help: true], [], []}, _serviceConfig, _serviceOpenWeather) do
    print_help()
    exit_success()
  end

  def process_args({[queryuser: true], [], []}, serviceConfig, serviceOpenWeather) do
    info("")
    success("Starting User interface")
    success("-----------------------")
    info("")
    inputFile = IO.gets("Configuration File [#{default_config_file()}] :")

    configFile =
      if String.trim(inputFile) == "", do: default_config_file(), else: String.trim(inputFile)

    inputLocation = IO.gets("City/State Code/Country Code to forecast [#{default_location()}] :")

    location =
      if String.trim(inputLocation) == "",
        do: default_location(),
        else: String.trim(inputLocation)

    process_args(
      {[file: configFile, location: location], [], []},
      serviceConfig,
      serviceOpenWeather
    )
  end

  # This is the only function you supposed to be
  # adding new features for the CLI (new command line options )
  def process_args({opts, params, []}, serviceConfig, serviceOpenWeather) do
    if not Enum.empty?(params) do
      debug("Ignoring unknow parameters: #{Enum.join(params, ", ")}")
    end

    case opts do
      [file: file, location: location] ->
        case serviceConfig.get_config_json(file) do
          {:error, :file_not_found} ->
            error("ERR: Trying to use '#{file}' configuration file, but it does not exists.")
            exit_error_config_file_not_found()

          {:ok, jsonConfig} ->
            debug("using configuration file: #{file}")

            case Sweatercli.SuggestionEngine.start(serviceOpenWeather, jsonConfig, location) do
              {:ok, _suggestions} ->
                exit_success()

              {:error, response} ->
                error("ERR: open weather returned a error.")
                IO.inspect(response, label: "open weather response")
                exit_error_open_weather_fail()
            end

          {:error, :invalid_config_file} ->
            Sweatercli.ConfigurationFile.print_invalid_config_file_help(file)
            exit_error_invalid_config_file()

          {:error, :io_error} ->
            error("ERR: error trying to read configuration file '#{file}'.")
            exit_error_config_io_error()
        end

      [location: location] ->
        process_args(
          {[file: default_config_file(), location: location], params, []},
          serviceConfig,
          serviceOpenWeather
        )

      _ ->
        wrongOptions()
        exit_error_wrong_options_combination()
    end
  end

  # ------------------------------------------------------------
  # When the user try to use options like --help or -X
  # together with other options this will generate a invalid
  # combination of options, that will result error message and
  # help printed
  # ------------------------------------------------------------
  defp wrongOptions() do
    error("Wrong Options combination! Please, read the Help:")
    info("")
    print_help()
  end

  # ----------------------------------------
  # This function print CLI help for users
  # sweatercli --help
  # ----------------------------------------
  defp print_help do
    warn("NAME")

    info(
      "\tsweatercli - (S)criptDrop (W)eather (E)valuation (A)nd (T)hermal (E)xcellence (R)ecommendations"
    )

    info("")
    warn("SYNOPSIS")
    info("\tsweatercli [OPTIONS]")
    info("")
    warn("DESCRIPTION")
    info("\tLook for weather on https://home.openweathermap.org/ and ")
    info("\tbased on the result for your location it will suggest clothing")
    info("\tand accessories based on the configuration file. If no --file option")
    info("\tis informed it will try use default configuration '#{default_config_file()}'.")
    info("\tIf configuration file does not exist or is invalid it will result a error.")
    info("")
    info("\tThe option --location is a mandatory!")
    info("")
    info("\t-f, --file=[JSON CONFIGURATION FILE]")
    debug("\t\tIf it is not informed CLI will try to use #{default_config_file()}")
    info("\t-l, --location=[CITY/STATE/COUNTRY]")
    debug("\t\tCity/State Code/Country Code to forecast.")
    info("\t-X, --queryuser")
    debug("\t\tStarts User Interface Mode.")
    info("\t-h, --help")
    debug("\t\tThis help.")
    info("")
    warn("USAGE")
    debug("\tInforming config file:")
    info("\t$ sweatercli --file=/home/ben/config.json --location=\"San Diego/CA/US\"")
    debug("\tUsing default config file:")
    info("\t$ sweatercli --location=\"Sao Paulo/SP/BR\"")
    debug("\tStarting User Interface:")
    info("\t$ sweatercli -X")
    info("")
    debug("\thave fun!")
    info("")
    warn("AUTHOR")
    info("\tPaulo AMF - San Diego - CA")
    info("\thttps://www.linkedin.com/in/amfpaulo/")
    info("")
    warn("TODO LIST")
    info("\t* Improve CLI outputs")
    info("\t* Improve Suggestions Algo taking")
    info("\t  in consideration not just temperature")
    info("\t* Check configuration File")
    info("\t* Add Authentication using key and secret")
    info("\t* Add new feature: Look up for Zip Code")
    info("\t* Add new feature: Look up for GPS coordinates")
    info("")
    warn("COPYRIGHT")
    info("\tCopyright © 2018 Free Software Foundation, Inc.")
    info("\tLicense GPLv3+: GNU GPL version 3 or later ")
    info("\t<https://gnu.org/licenses/gpl.html>. This is ")
    info("\tfree software: you are free to change and redistribute it.")
    info("\tThere is NO  WAR‐RANTY, to the extent permitted by law.")
  end
end
