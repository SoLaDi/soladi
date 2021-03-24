module ApplicationHelper
  def self.range_to_months(start_date, end_date)
    (start_date..end_date).uniq { |d| "#{d.month}-#{d.year}" }
  end

  def self.fiscal_year_to_month_range(year)
    start_date = Date.new(year, 4, 1)
    end_date = Date.new(year + 1, 3, 1)
    range_to_months(start_date, end_date)
  end

  def self.date_to_fiscal_year(date)
    if date.month > 3
      date.year
    else
      date.year - 1
    end
  end
end
