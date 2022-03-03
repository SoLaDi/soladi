class Api::MagicAuthController < Api::ApiController
  def login
    @person = Person.where(login_token: token_param).first!
    render json: {
      "person_id": @person.id,
      "name": @person.name,
      "surname": @person.surname,
      "email": @person.email,
      "membership": {
        "id": @person.membership_id,
        "users": @person.membership.people.map { |p| p.as_json(only: %w[id name surname email]) },
        "bids": @person.membership.bids.map do |p|
          p.as_json(only: %w[id start_date end_date amount shares created_at person_id])
        end
      }
    }
  end

  private

  def token_param
    params.require(:token)
  end
end
