class Api::ApiController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  TOKEN = ENV['API_TOKEN']

  before_action :authenticate

  def render_unauthorized
    render json: nil, status: :unauthorized
  end

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, _options|
      # Compare the tokens in a time-constant manner, to mitigate
      # timing attacks.
      ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
    end
  end
end
