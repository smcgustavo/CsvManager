defmodule CsvManager.Data do
  defstruct [
    file: nil,
    file_name: nil,
    number_of_rows: 0,
    number_of_columns: 0,
    sep: ",",
    parsed_data: nil
  ] 
end
