class CreateBids < ActiveRecord::Migration[6.0]
  def change
    create_table :bids do |t|
      t.date :start_date
      t.date :end_date
      t.decimal :amount
      t.integer :shares
      t.boolean :contract_signed
      t.references :membership, null: false, foreign_key: true

      t.timestamps
    end
  end
end
