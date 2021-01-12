# == Schema Information
#
# Table name: transactions
#
#  id            :integer          not null, primary key
#  entry_date    :date
#  sender        :string
#  description   :string
#  amount        :decimal(, )
#  currency      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  membership_id :integer
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
    invalid_rows = []

    CSV.foreach(file.path, headers: false, col_sep: ";") do |row|
      total_rows_count += 1

      # filter header lines
      if row.at(0).nil? || row.at(0) == "Buchung"
        invalid_rows.push row
      else

        # filter lines with empty amounts
        if row.at(8).nil?
          invalid_rows.push row
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
                amount: amount.tr(',','.').to_d,
                currency: row.at(9)
              )

              if transaction.save
                imported_rows.push row
              else
                puts transaction.errors.full_messages
                invalid_rows.push row
              end

            rescue ActiveRecord::RecordNotUnique
              duplicate_rows.push row
              puts "Record already exists"
            end
          else
            invalid_rows.push row
          end
        end
      end
    end

    puts "total rows: #{total_rows_count}"
    puts "imported rows: #{imported_rows.length}"
    puts "duplicate rows: #{duplicate_rows.length}"
    puts "invalid rows: #{invalid_rows.length}"
  end
end
