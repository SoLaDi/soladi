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
  validates_with BidValidator

  scope :active_between, ->(start_date, end_date) {
    where(start_date: ..start_date, end_date: end_date..)
  }

  def overlaps?(other)
    id == other.id && start_date <= other.end_date && other.start_date <= end_date
  end

  def period
    start_date..end_date
  end

  def self.total_amount(start_date, end_date)
    Bid.active_between(start_date, end_date).inject(0) do |sum, bid|
      sum + bid.total_amount
    end
  end

  def self.total_shares(date)
    Bid.active_between(date, date).sum(:shares)
  end

  def self.import(file)
    total_rows_count = 0
    imported_rows = []
    duplicate_rows = []
    ignored_rows = []
    invalid_rows = []

    # CSV columns: membership_id, fiscal_year, shares, price_per_share
    CSV.foreach(file.path, "r", headers: true, col_sep: ",", encoding: "utf-8") do |row|
      total_rows_count += 1

      membership_id = row["membership_id"].to_i
      fiscal_year = row["fiscal_year"].to_i
      shares = row["shares"].to_i
      price_per_share = row["price_per_share"].to_d

      amount = price_per_share > 0.0 ? price_per_share : 84.5

      if not self.is_valid_csv_row(membership_id, fiscal_year, shares)
        ignored_rows.push row
      else
        bid = Bid.new(membership_id: membership_id, start_date: Date.new(fiscal_year, 4, 1), end_date: Date.new(fiscal_year + 1, 3, 1), amount: amount, shares: shares)
        begin
          if bid.save
            imported_rows.push row
          else
            puts "############ BROKEN TRANSACTION BELOW ############"
            puts bid.inspect
            puts bid.errors.full_messages
            invalid_rows.push row
          end
        rescue ActiveRecord::RecordNotUnique
          duplicate_rows.push row
        end
      end
    end

    puts "total rows: #{total_rows_count}"
    puts "imported rows: #{imported_rows.length}"
    puts "duplicate rows: #{duplicate_rows.length}"
    puts "ignored rows: #{ignored_rows.length}"
    puts "invalid rows: #{invalid_rows.length}"

    ImportStatus.new(total_rows_count, imported_rows.length, duplicate_rows.length, ignored_rows.length, invalid_rows.length)
  end

  def self.is_valid_csv_row(membership_id, fiscal_year, shares)
    valid = (membership_id > 0 && shares > 0 && fiscal_year > 0)
    unless valid
      puts "INVALID ROW"
      puts "membership_id: #{membership_id}"
      puts "fiscal_year: #{fiscal_year}"
      puts "shares: #{shares}"
    end
    valid
  end

  def monthly_amount
    self.amount * self.shares
  end

  def total_amount
    months.length * self.amount
  end

  def months
    ApplicationHelper.range_to_months(self.start_date, self.end_date)
  end

  def monthly_amounts
    ApplicationHelper.range_to_months(self.start_date, self.end_date).map { |month|
      [month, self.monthly_amount]
    }.to_h
  end
end
