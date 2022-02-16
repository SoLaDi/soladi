class ApplicationController < ActionController::Base
  protected

  before_action :authenticate_user!

  before_action :set_paper_trail_whodunnit

  add_flash_types :info, :error, :warning
end
