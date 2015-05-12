class Admin::DashboardController < ApplicationController
  layout "admin"
  before_filter :authenticate_admin!

  def index
    @user_count = User.count
  end
end
