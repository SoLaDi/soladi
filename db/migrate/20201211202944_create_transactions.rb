class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.date :entry_date
      t.string :sender
      t.string :description
      t.decimal :amount
      t.string :currency
      t.string :status_message

      t.timestamps
      t.index [:entry_date, :sender, :description, :amount, :currency], unique: true, name: 'transactions_unique'
    end
  end
end
