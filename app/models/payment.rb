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

      begin
        if p.save
          puts "successfully persisted"
        else
          puts p.errors.inspect
        end
      rescue ActiveRecord::RecordNotUnique
        puts "Payment already exists"
        existing_payment = Payment.where(year: item.year.to_i, month: item.month.to_i, membership_id: item.membership_id).take
        puts existing_payment.inspect

        existing_payment.amount = item.total_amount
        existing_payment.save
      end
    end
  end
end
