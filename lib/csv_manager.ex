defmodule CsvManager do
  @moduledoc """
  CsvManager is a csv manipulator built with and made for elixir programs.
  """

  @doc """
    Function that reads the file by a filename.
    Inputs: `filename` (name of the file), `sep` (character that separates columns).

  ## Example
      iex> CsvManager.read_file("example.csv", ";")
      "The example.csv couldn't be read by: enoent"
  """
  def read_file(filename, sep) do
    case File.read(filename) do
      {:ok, file} -> %CsvManager.Data{file: file, sep: sep, file_name: filename}
      {:error, reason} -> raise "The #{filename} couldn't be read by: #{reason}"
    end
  end

  def parse_data(%CsvManager.Data{file: file, sep: sep} = data) do
    rows = String.split(file, "\n") 
    parsed_data 
      = 
      for row <- rows do
        String.split(row, sep)
      end
    %CsvManager.Data{data | parsed_data: parsed_data}
  end

  def read(filename, sep) do
    read_file(filename, sep)
    |> parse_data
  end

  def read(filename) do
    read_file(filename, ",")
    |> parse_data
  end
end
