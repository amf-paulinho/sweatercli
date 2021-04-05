defmodule Sweatercli.Output do
  @moduledoc false

  @doc false
  def info(message), do: [:normal, message] |> IO.ANSI.format() |> IO.puts()

  @doc false
  def infonoreturn(message), do: [:normal, message] |> IO.ANSI.format() |> IO.write()

  @doc false
  def debug(message), do: [:faint, message] |> IO.ANSI.format() |> IO.puts()

  @doc false
  def success(message), do: [:green, message] |> IO.ANSI.format() |> IO.puts()

  @doc false
  def warn(message), do: [:yellow, message] |> IO.ANSI.format() |> IO.puts()

  @doc false
  def fun(message), do: [:magenta, message] |> IO.ANSI.format() |> IO.puts()

  @doc false
  def error(message) do
    formattedMsg = IO.ANSI.format([:red, message])
    IO.puts(:stderr, formattedMsg)
  end
end
