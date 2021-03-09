# == Schema Information
#
# Table name: prices
#
#  id            :integer          not null, primary key
#  month         :integer
#  year          :integer
#  shares        :integer
#  amount        :decimal(, )
#  membership_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Price < ApplicationRecord
  belongs_to :membership

  def self.import(file)
    total_rows_count = 0
    imported_rows = []
    duplicate_rows = []
    ignored_rows = []
    invalid_rows = []

    # CSV columns: membership_id, fiscal_year, shares, price_per_share
    CSV.foreach(file.path, "r", headers: true, col_sep: ",", encoding: "utf-8") do |row|
      total_rows_count += 1

      membership_id = row["membership_id"]
      fiscal_year = row["fiscal_year"].to_i
      shares = row["shares"]
      price_per_share = row["price_per_share"]

      # startDate should be beginning of fiscal year
      @membership = Membership.find(membership_id)

      @membership.fiscal_year_to_month_range(fiscal_year).each do |date|
        @membership.prices.build(amount: price_per_share, shares: shares, month: date.month, year: date.year)
      end

      @membership.save
    end

    puts "total rows: #{total_rows_count}"
    puts "imported rows: #{imported_rows.length}"
    puts "duplicate rows: #{duplicate_rows.length}"
    puts "ignored rows: #{ignored_rows.length}"
    puts "invalid rows: #{invalid_rows.length}"

    ImportStatus.new(total_rows_count, imported_rows.length, duplicate_rows.length, ignored_rows.length, invalid_rows.length)
  end

  def total
    self.amount * self.shares
  end
end
