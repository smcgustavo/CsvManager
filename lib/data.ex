defmodule CsvManager.Data do
  defstruct [
    file: nil,
    file_name: nil,
    columns: nil,
    number_of_rows: nil,
    number_of_columns: nil,
    sep: ",",
    parsed_data: nil
  ] 
end
