# == Schema Information
#
# Table name: bids
#
#  id              :integer          not null, primary key
#  start_date      :date
#  end_date        :date
#  amount          :decimal(, )
#  shares          :integer
#  contract_signed :boolean
#  membership_id   :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Bid < ApplicationRecord
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

      bid = Bid.new(membership_id: membership_id, start_date: Date.new(fiscal_year, 4, 1), end_date: Date.new(fiscal_year + 1, 3, 1), amount: price_per_share, shares: shares)
      begin
        if bid.save
          imported_rows.push row
        else
          puts "############ BROKEN TRANSACTION BELOW ############"
          puts bid.errors.full_messages
          invalid_rows.push row
        end
      rescue ActiveRecord::RecordNotUnique
        duplicate_rows.push row
      end
    end

    puts "total rows: #{total_rows_count}"
    puts "imported rows: #{imported_rows.length}"
    puts "duplicate rows: #{duplicate_rows.length}"
    puts "ignored rows: #{ignored_rows.length}"
    puts "invalid rows: #{invalid_rows.length}"

    ImportStatus.new(total_rows_count, imported_rows.length, duplicate_rows.length, ignored_rows.length, invalid_rows.length)
  end

  def total_amount
    self.amount * self.shares
  end
end
