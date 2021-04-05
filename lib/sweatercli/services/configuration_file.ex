defmodule Sweatercli.ConfigurationFileBehavior do
  @callback get_config_json(configFile :: any) :: any
  @callback print_invalid_config_file_help(configFile :: any) :: any
end

defmodule Sweatercli.ConfigurationFile do
  @behaviour Sweatercli.ConfigurationFileBehavior
  import Sweatercli.Output

  @impl true
  def get_config_json(configFile) do
    if not File.exists?(configFile) do
      {:error, :file_not_found}
    else
      case File.read(configFile) do
        {:ok, body} ->
          case Poison.decode!(body, as: %{}) do
            %{"recommendations" => jsonConfig} ->
              {:ok, jsonConfig}

            _ ->
              {:error, :invalid_config_file}
          end

        {:error, :enoent} ->
          {:error, :io_error}
      end
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
