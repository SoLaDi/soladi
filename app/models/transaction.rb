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
#
class Transaction < ApplicationRecord
  belongs_to :membership, optional: true

  validates :entry_date, presence: true
  validates :sender, presence: true
  validates :description, presence: true
  validates :amount, presence: true
  validates :currency, presence: true

  require 'csv'
  require 'bigdecimal'
  require 'bigdecimal/util'

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
                amount: amount.tr(',', '.').to_d,
                currency: row.at(9)
              )

              begin
                transaction.membership_id = extract_membership_id(row.at(7))
              rescue ParserError => e
                transaction.status_message = e.message
              end

              if transaction.save
                imported_rows.push row
              else
                puts "############ BROKEN TRANSACTION BELOW ############"
                puts transaction.errors.full_messages
                invalid_rows.push row
              end

            rescue ActiveRecord::RecordNotUnique
              duplicate_rows.push row
              puts "Record already exists: #{transaction.inspect}"
            end
          else
            ignored_rows.push row
          end
        end
      end
    end

    puts "total rows: #{total_rows_count}"
    puts "imported rows: #{imported_rows.length}"
    puts "duplicate rows: #{duplicate_rows.length}"
    puts "ignored rows: #{ignored_rows.length}"
    puts "invalid rows: #{invalid_rows.length}"

    import_status = ImportStatus.new(total_rows_count, imported_rows.length, duplicate_rows.length, ignored_rows.length, invalid_rows.length)

    Payment.generate
    import_status
  end

  def self.extract_membership_id(description)
    matches = description.scan(/S\d{4}/)
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
