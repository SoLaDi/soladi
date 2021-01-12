# == Schema Information
#
# Table name: payments
#
#  id            :integer          not null, primary key
#  month         :date
#  amount        :decimal(, )
#  membership_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Payment < ApplicationRecord
  belongs_to :membership

  def self.generate
    result = Transaction.select("id, strftime('%m',entry_date) as month, strftime('%Y',entry_date) as year, membership_id, sum(amount) as total_amount").group(:membership_id, :year, :month)
    result.each do |item|
      p = Payment.new(
        year: item.year.to_i,
        month: item.month.to_i,
        amount: item.total_amount,
        membership_id: item.membership_id)
      puts p.inspect
      if p.save
        puts "successfully persisted"
      else
        puts p.errors.inspect
      end
    end
  end
end
