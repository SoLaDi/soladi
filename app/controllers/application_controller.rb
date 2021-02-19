class ApplicationController < ActionController::Base
    protected

    before_action :authenticate_user!

    add_flash_types :info, :error, :warning

    def authenticate_inviter!
        authenticate_admin!(force: true)
      end
end
