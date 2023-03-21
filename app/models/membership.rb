require 'date'

# == Schema Information
#
# Table name: memberships
#
#  id                    :integer          not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  distribution_point_id :integer          not null
#  terminated            :boolean          default(FALSE), not null
#
class Membership < ApplicationRecord
  has_many :transactions
  has_many :payments
  has_many :bids
  has_many :people
  belongs_to :distribution_point
  accepts_nested_attributes_for :bids

  has_paper_trail ignore: [:updated_at]

  def self.to_csv
    attributes = %w{id created_at updated_at distribution_point_id terminated}

    CSV.generate(headers: true) do |csv|
      csv << attributes + %w[currently_active active_next_business_year, active_users, needs_new_bid]

      all.each do |membership|
        base_attributes = attributes.map { |attr| membership.send(attr) }

        currently_active = membership.currently_active?
        active_next_business_year = membership.active_at(Date.today + 1.year)
        active_users_count = membership.people.all.where("website_account_status" == "approved").count
        needs_new_bid = (!membership.terminated and !active_next_business_year)

        bid_attributes = [currently_active, active_next_business_year, active_users_count, needs_new_bid]
        csv << base_attributes + bid_attributes
      end
    end
  end

  def self.import(file)
    total_rows_count = 0
    imported_rows = []
    duplicate_rows = []
    ignored_rows = []
    invalid_rows = []

    # CSV columns: membership_id, distribution_point_id
    CSV.foreach(file.path, 'r', headers: true, col_sep: ',', encoding: 'utf-8') do |row|
      total_rows_count += 1

      membership_id = row['membership_id']
      distribution_point_id = row['distribution_point_id']

      if Membership.exists?(membership_id)
        duplicate_rows.push row
      else
        membership = Membership.new(id: membership_id, distribution_point_id: distribution_point_id)
        if membership.save
          imported_rows.push row
        else
          Rails.logger.info '############ BROKEN TRANSACTION BELOW ############'
          Rails.logger.info membership.inspect
          Rails.logger.info membership.errors.full_messages
          invalid_rows.push row
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

  def send_payment_overdue_reminder_mail
    active_members.each do |recipient|
      Rails.logger.info("Will send overdue reminder mail to #{recipient.email}")
      PeopleMailer.with(person: recipient).payment_overdue_reminder_mail.deliver_now
    end
  end

  def send_bidding_invite_mail
    active_members.map do |recipient|
      Rails.logger.info("Will send bidding invite mail to #{recipient.email}")
      PeopleMailer.with(person: recipient).bidding_round_invite_mail.deliver_now
      1
    end.sum
  end

  def active_members
    people.all.filter(&:active?)
  end

  # Return a list of dates for every month a membership has been active
  # @return [Array<Date>]
  def total_months
    now = Date.today
    end_date = self.end_date < now ? self.end_date : now
    range_to_months(start_date, end_date)
  end

  def total_cost
    today = Date.today
    bids.all.inject(0) do |total_sum, bid|
      total_sum + bid.months.inject(0) do |bid_sum, bid_month|
        if bid_month < today
          bid_sum + bid.monthly_amount
        else
          bid_sum
        end
      end
    end
  end

  def cost_for_fiscal_year(year)
    bids.active_between(Date.new(year, 4), Date.new(year + 1, 3)).inject(0) do |sum, bid|
      sum + bid.monthly_amount
    end
  end

  def total_payments
    transactions.sum(:amount)
  end

  def total_balance
    total_payments - total_cost
  end

  def payments_for_fiscal_year(year)
    transactions.where(entry_date: Date.new(year, 4)..Date.new(year + 1, 3)).sum(:amount)
  end

  def bid_for(date)
    # bid dates always have the day set to 1
    query_date = Date.new(date.year, date.month, 1)
    bids.where(start_date: ..query_date, end_date: query_date..).take
  end

  def currently_active?
    active_at(Date.today)
  end

  def current_bid
    bid_for(Date.today)
  end

  def active_at(date)
    !bid_for(date).nil?
  end

  def self.overdue
    Membership.all.filter do |m|
      m.total_balance.negative?
    end
  end

  def self.active
    Membership.all.filter(&:currently_active?)
  end

  def self.active_count
    active.count
  end

  def self.total_count
    Membership.all.count
  end

  def self.without_bid_for(date)
    Membership.where(terminated: false).filter do |m|
      !m.bid_for(date)
    end
  end

  def start_date
    earliest_starting_bid = bids.map { |b| [b.start_date, b] }.to_h.sort.to_h.values.first
    earliest_starting_bid ? earliest_starting_bid.start_date : nil
  end

  def end_date
    if terminated
      latest_ending_bid = bids.map { |b| [b.end_date, b] }.to_h.sort.to_h.values.last
      latest_ending_bid ? latest_ending_bid.end_date : nil
    else
      nil
    end
  end

end
