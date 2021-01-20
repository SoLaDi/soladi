class CreatePrices < ActiveRecord::Migration[6.0]
  def change
    create_table :prices do |t|
      t.integer :month
      t.integer :year
      t.integer :shares
      t.decimal :amount
      t.belongs_to :membership, null: false, foreign_key: true

      t.index [:year, :month, :membership_id], unique: true, name: 'prices_unique'
      t.timestamps
    end
  end
end
