class AddMembershipToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_reference :transactions, :membership, null: true, foreign_key: true
  end
end
