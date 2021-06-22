# == Schema Information
#
# Table name: transactions
#
#  id             :integer          not null, primary key
#  entry_date     :date
#  sender         :string
#  description    :string
#  amount         :decimal(, )
#  currency       :string
#  status_message :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  membership_id  :integer
#  status         :string           default("ok"), not null
#
class Transaction < ApplicationRecord
  belongs_to :membership, optional: true

  validates :entry_date, presence: true
  validates :sender, presence: true
  validates :amount, presence: true
  validates :currency, presence: true

  has_paper_trail

  require 'csv'
  require 'bigdecimal'
  require 'bigdecimal/util'

  scope :associated_with_membership, ->() {
    where.not(membership_id: nil)
  }

  scope :not_associated, ->() {
    where(membership_id: nil).where.not(status: "ignored")
  }

  def self.total_amount(start_date, end_date)
    Transaction
      .associated_with_membership
      .where(entry_date: start_date..end_date)
      .sum(:amount)
  end

  def self.total_amount_not_associated(start_date, end_date)
    Transaction
      .not_associated
      .where(entry_date: start_date..end_date)
      .sum(:amount)
  end

  def self.import(file)
    total_rows_count = 0
    imported_rows = []
    duplicate_rows = []
    ignored_rows = []
    invalid_rows = []

    CSV.foreach(file.path, "r", headers: false, col_sep: ";", encoding: "windows-1252:utf-8") do |row|
      total_rows_count += 1

      # filter header lines
      if row.at(0).nil? || row.at(0) == "Buchung"
        ignored_rows.push row
      else

        # filter lines with empty amounts
        if row.at(8).nil?
          ignored_rows.push row
        else
          amount, type = row.at(8).strip.split

          # we're only interested in incoming money, thus
          # filter for incoming transactions (S == soll == outgoing / H == haben == incoming)
          if type == "H"
            begin
              transaction = Transaction.new(
                entry_date: row.at(0),
                sender: row.at(4),
                description: row.at(7),
                amount: amount.tr('.', '').tr(',', '.').to_d,
                currency: row.at(9),
                status: "ok"
              )

              Rails.logger.info transaction.inspect
              unless transaction.description
                Rails.logger.info "EMPTY_DESCRIPTION"
                Rails.logger.info transaction.inspect
              end

              begin
                transaction.membership_id = extract_membership_id(row.at(7))
              rescue ParserError => e
                Rails.logger.info "Parsererror for #{row.inspect}"
                transaction.status_message = e.message
                transaction.status = "needs_attention"
              end

              if transaction.save
                imported_rows.push row
              else
                Rails.logger.info "############ BROKEN TRANSACTION BELOW ############"
                Rails.logger.info transaction.errors.full_messages
                invalid_rows.push row
              end

            rescue ActiveRecord::RecordNotUnique
              duplicate_rows.push row
              Rails.logger.info "Record already exists: #{transaction.inspect}"
            end
          else
            ignored_rows.push row
          end
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

  def self.extract_membership_id(description)
    unless description
      raise ParserError.new("Die Transaktion enthält keinen Buchungstext")
    end

    cleaned_description = description.gsub(/\s+/, "").gsub(/\./, "")
    matches = cleaned_description.scan(/S\d{4}/)
    if matches.length == 0
      raise ParserError.new("Keine Mitgliedschaftsnummer gefunden")
    elsif matches.length == 1
      id = matches.first[1..-1]
      if Membership.exists?(id)
        id
      else
        raise ParserError.new("Mitgliedschaft mit der Nummer S#{id} nicht im System gefunden")
      end
    else
      raise ParserError.new("Es wurden mehrere Möglichkeiten für die Mitgliedschaftsnummer gefunden: #{matches}")
    end
  end
end
