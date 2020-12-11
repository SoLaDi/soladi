class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.date :entry_date
      t.string :sender
      t.string :description
      t.decimal :amount
      t.string :currency

      t.timestamps
    end
  end
end
