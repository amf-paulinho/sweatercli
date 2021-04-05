defmodule Sweatercli.AppConstants do
  @moduledoc false

  @default_config_file "/etc/sweatercli.conf"
  @default_location "San Diego/CA/US"
  @api_key "a33edafecb11d20b0dbf0e19a7d0e082"

  def default_config_file, do: @default_config_file
  def default_location, do: @default_location
  def api_key, do: @api_key
end
