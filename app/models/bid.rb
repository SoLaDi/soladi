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
#  person_id       :integer
#
class Bid < ApplicationRecord
  belongs_to :membership
  belongs_to :person, optional: true

  validates_with BidValidator
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :amount, presence: true
  validates :shares, presence: true

  has_paper_trail ignore: [:updated_at]

  scope :active_at, ->(date) {
    normalised_date = Date.new(date.year, date.month, 1)
    where(start_date: ..normalised_date, end_date: normalised_date..)
  }

  def overlaps?(other)
    id == other.id && start_date <= other.end_date && other.start_date <= end_date
  end

  def period
    start_date..end_date
  end

  def self.total_amount(start_date, end_date)
    Rails.cache.fetch('total_amount' + start_date.strftime("%d-%m-%Y") + end_date.strftime("%d-%m-%Y"), expires_in: 1.hour) do
      ApplicationHelper.range_to_months(start_date, end_date).inject(0) do |total, month|
        total + Bid.active_at(month).inject(0) do |sum, bid|
          sum + bid.monthly_amount
        end
      end
    end
  end

  def self.average_amount_by_share(start_date, end_date)
    ApplicationHelper.range_to_months(start_date, end_date).inject(0) do |total, month|
      total + Bid.active_at(month).inject(0) do |sum, bid|
        sum + bid.monthly_amount
      end
    end
  end

  def self.total_shares(date)
    Rails.cache.fetch('total_shares_' + date.strftime("%d-%m-%Y"), expires_in: 1.hour) do
      Bid.active_at(date).sum(:shares)
    end
  end

  def self.average_share_price(date)
    active_bids = Bid.active_at(date)
    shares = active_bids.sum(:shares)
    total = active_bids.map(&:monthly_amount).sum
    shares.nonzero? ? total / shares : 0
  end

  def self.import(file)
    total_rows_count = 0
    imported_rows = []
    duplicate_rows = []
    ignored_rows = []
    invalid_rows = []

    # CSV columns: membership_id, fiscal_year, shares, price_per_share
    CSV.foreach(file.path, 'r', headers: true, col_sep: ',', encoding: 'utf-8') do |row|
      total_rows_count += 1

      membership_id = row['membership_id'].to_i
      fiscal_year = row['fiscal_year'].to_i
      shares = row['shares'].to_i
      price_per_share = row['price_per_share'].to_d

      amount = price_per_share > 0.0 ? price_per_share : 84.5

      if not valid_csv_row(membership_id, fiscal_year, shares)
        ignored_rows.push row
      else
        bid = Bid.new(membership_id: membership_id, start_date: Date.new(fiscal_year, 4, 1), end_date: Date.new(fiscal_year + 1, 3, 1), amount: amount, shares: shares)
        begin
          if bid.save
            imported_rows.push row
          else
            Rails.logger.info '############ BROKEN TRANSACTION BELOW ############'
            Rails.logger.info bid.inspect
            Rails.logger.info bid.errors.full_messages
            invalid_rows.push row
          end
        rescue ActiveRecord::RecordNotUnique
          duplicate_rows.push row
        end
      end
    end

    Rails.logger.info "total rows: #{total_rows_count}"
    Rails.logger.info "imported rows: #{imported_rows.length}"
    Rails.logger.info "duplicate rows: #{duplicate_rows.length}"
    Rails.logger.info "ignored rows: #{ignored_rows.length}"
    Rails.logger.info "invalid rows: #{invalid_rows.length}"

    ImportStatus.new(total_rows_count, imported_rows.length, duplicate_rows.length, ignored_rows.length, invalid_rows.length)
  end

  def self.valid_csv_row(membership_id, fiscal_year, shares)
    valid = (membership_id.positive? && shares.positive? && fiscal_year.positive?)
    unless valid
      Rails.logger.info 'INVALID ROW'
      Rails.logger.info "membership_id: #{membership_id}"
      Rails.logger.info "fiscal_year: #{fiscal_year}"
      Rails.logger.info "shares: #{shares}"
    end
    valid
  end

  def monthly_amount
    amount * shares
  end

  def total_amount
    months.length * amount
  end

  def months
    ApplicationHelper.range_to_months(start_date, end_date)
  end

  def monthly_amounts
    ApplicationHelper.range_to_months(start_date, end_date).map { |month|
      [month, monthly_amount]
    }.to_h
  end

  def self.fill_missing_bids(fiscal_year, amount)
    start_date = Date.new(fiscal_year, 4)
    end_date = Date.new(fiscal_year + 1, 3)
    Membership.without_bid_for(start_date).each do |m|
      Rails.logger.info "Membership #{m.id} is missing a bid for #{fiscal_year}. Going to create one."
      bid = m.bids.new(start_date: start_date, end_date: end_date, amount: amount, shares: 1)
      bid.save!
    end
  end
end
