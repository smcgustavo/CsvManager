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
  
  @doc """
    Function responsible for parsing the string into a list of lists.
  """
  def parse_data(%CsvManager.Data{file: file, sep: sep} = data) do
    rows = String.split(file, "\n") 
    [first | _tail] = rows 
    [_head | parsed_data] 
      = 
      for row <- rows do
        List.to_tuple(String.split(row, sep))
      end
    
    %CsvManager.Data{
      data | 
      parsed_data: List.to_tuple(parsed_data), 
      number_of_rows: length(rows) - 1,
      columns: first,
      number_of_columns: length(String.split(first, sep))
    }
  end

  @doc """
    Display csv info.
    Inputs `%CsvManager.Data`(the data structure)
  
  """
  def csv_info(%CsvManager.Data{file_name: name, number_of_rows: n_rows, number_of_columns: n_cols, columns: cols}) do
    IO.puts("Name: #{name}\nNumber of Rows: #{n_rows}\nNumber of Columns: #{n_cols}\nColumns: #{cols}")
  end
  
  @doc """
    Main function to read a csv file.
    Inputs `filename`(the file name) and `sep`(character to split the rows)
  
  """
  def read_csv(filename, sep) do
    read_file(filename, sep)
    |> parse_data
  end
  
  @doc """
    Function to create map with columns-> column_index
  """
  def map_columns(%CsvManager.Data{columns: columns, sep: sep} = data) do
    columns_map = 
      columns
      |> String.split(sep)
      |> Enum.with_index
      |> Map.new
    %CsvManager.Data{ data | columns_map: columns_map}
  end
  
  @doc """
    
    Returns a specific row from the data
    Inputs `data` and `number` (number of the row)      
  
  """
  def get_row(%CsvManager.Data{parsed_data: parsed_data, number_of_rows: number_of_rows}, number) do
    case number > 0 && number < number_of_rows do
      true -> elem(parsed_data, number)
      false -> "Row number out of range."
    end
  end
  
  @doc """
    
    Acess all the values from a column
    Inputs `data` and `column_name`

  """
  def get_column(%CsvManager.Data{parsed_data: parsed_data, columns_map: columns_map}, column_name) do
    index = Map.fetch(columns_map, column_name)
    if index == :error do 
      raise "This columns couldn't be acessed."
    end
    {_status, value} = index
    
    for row <- Tuple.to_list(parsed_data) do
      elem(row, value)
    end
  end

  @doc """
    Main function to read a csv file.
    Input `filename`(the file name) the module estipulates a "," for spliting rows
    
  """
  def read_csv(filename) do
    read_file(filename, ",")
    |> parse_data
    |> map_columns
  end
  
end
