# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  entry_date  :date
#  sender      :string
#  description :string
#  amount      :decimal(, )
#  currency    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Transaction < ApplicationRecord
    require 'csv'
    
    def self.import(file)
        puts file
        CSV.foreach(file.path, headers:false, col_sep:";") do |row|

            unless row.at(0).nil? || row.at(0) == "Buchung"
                puts row
                amount = row.at(8).split().at(1)

                newTransaction = Transaction.create(
                    entry_date: row.at(0),
                    sender: row.at(4),
                    description: row.at(7),
                    amount: amount,
                    currency: row.at(9)
                )
            end
        end
    end
end
