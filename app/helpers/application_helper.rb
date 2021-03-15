module ApplicationHelper
  def format_currency_value(number)
    number_to_currency(number, unit: "€", separator: ",", delimiter: ".", format: "%n %u")
  end
end
