# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # AuthenticatedSystem must be included for RoleRequirement, and is provided by installing acts_as_authenticates and running 'script/generate authenticated account user'.
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem


  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging  :password, :password_confirmation
  
  # --------------------------- private -----------------------------
  private
  
  def parse_page_number(page)
    page.to_i == 0 ? 1 : page.to_i
  end

  def redirect_to_root_path_with_error_message
    flash[:error] = PAGE_NOT_FOUND and redirect_to root_path and return    
  end
  
end
