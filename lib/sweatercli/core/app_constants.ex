defmodule Sweatercli.AppConstants do
  @moduledoc false

  @default_config_file "/etc/sweatercli.conf"
  @default_location "San Diego/CA/US"
  @api_key "a33edafecb11d20b0dbf0e19a7d0e082"

  # all CLI that execution succeed must return Zero
  @exit_success 0

  # all CLI that execution fail must return greater than Zero
  # error codes open to use: 1 and 3 to 125 (Other codes have special meaning for unix system)
  # Generic Error
  @exit_error 1

  @exit_error_invalid_options 10
  @exit_error_wrong_options_combination 11

  @exit_error_config_file_not_found 20
  @exit_error_invalid_config_file 21
  @exit_error_config_io_error 22

  @exit_error_open_weather_fail 30

  def default_config_file, do: @default_config_file
  def default_location, do: @default_location
  def api_key, do: @api_key

  def exit_success, do: @exit_success

  def exit_error, do: @exit_error

  def exit_error_invalid_options, do: @exit_error_invalid_options
  def exit_error_wrong_options_combination, do: @exit_error_wrong_options_combination

  def exit_error_config_file_not_found, do: @exit_error_config_file_not_found
  def exit_error_invalid_config_file, do: @exit_error_invalid_config_file
  def exit_error_config_io_error, do: @exit_error_config_io_error

  def exit_error_open_weather_fail, do: @exit_error_open_weather_fail
end
