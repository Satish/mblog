class Admin::DashboardController < Admin::BaseController

  def index
    render :text => "Welcome to dashboard"
  end

end
