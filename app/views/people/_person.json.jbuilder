json.extract! person, :id, :name, :surname, :email, :phone, :membership_id, :created_at, :updated_at
json.url person_url(person, format: :json)
