class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.integer :month
      t.integer :year
      t.decimal :amount
      t.belongs_to :membership, null: false, foreign_key: true

      t.index [:month, :year, :membership_id], unique: true, name: 'payments_unique'
      t.timestamps
    end
  end
end
