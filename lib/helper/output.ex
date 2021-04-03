defmodule Sweatercli.Output do
  def info(message), do: [:normal, message] |> IO.ANSI.format() |> IO.puts()
  def infonoreturn(message), do: [:normal, message] |> IO.ANSI.format() |> IO.write()
  def debug(message), do: [:faint, message] |> IO.ANSI.format() |> IO.puts()
  def success(message), do: [:green, message] |> IO.ANSI.format() |> IO.puts()
  def warn(message), do: [:yellow, message] |> IO.ANSI.format() |> IO.puts()
  def fun(message), do: [:magenta, message] |> IO.ANSI.format() |> IO.puts()

  def error(message) do
    formattedMsg = IO.ANSI.format([:red, message])
    IO.puts(:stderr, formattedMsg)
  end
end
