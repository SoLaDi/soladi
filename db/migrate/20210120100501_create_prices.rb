class CreatePrices < ActiveRecord::Migration[6.0]
  def change
    create_table :prices do |t|
      t.integer :year
      t.decimal :amount
      t.belongs_to :membership, null: false, foreign_key: true

      t.index [:year, :membership_id], unique: true, name: 'prices_unique'
      t.timestamps
    end
  end
end
