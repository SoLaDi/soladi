class ImportStatus
  def initialize(total_rows, imported_rows, duplicate_rows, invalid_rows)
    @total_rows = total_rows
    @imported_rows = imported_rows
    @duplicate_rows = duplicate_rows
    @invalid_rows = invalid_rows


  end

  attr_reader :total_rows
  attr_reader :imported_rows
  attr_reader :duplicate_rows
  attr_reader :invalid_rows

  def message
    "Zeilenstatistik: verarbeitet=#{total_rows}, importiert=#{imported_rows}, doppelt=#{duplicate_rows}, fehlerhaft=#{invalid_rows}"
  end
end