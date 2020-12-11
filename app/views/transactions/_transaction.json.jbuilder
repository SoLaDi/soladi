json.extract! transaction, :id, :entry_date, :sender, :description, :amount, :currency, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
