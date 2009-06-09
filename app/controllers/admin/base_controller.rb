class Admin::BaseController < ApplicationController
  
  require_role "admin"

end
