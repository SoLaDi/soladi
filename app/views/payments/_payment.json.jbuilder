json.extract! payment, :id, :month, :amount, :memberships_id, :created_at, :updated_at
json.url payment_url(payment, format: :json)
