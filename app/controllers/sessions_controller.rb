# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # render new.html.erb
  def new
    redirect_back_or_default(current_user.has_role?('admin') ? admin_root_path : root_path) if current_user
  end

  def create
    using_open_id? ? open_id_authentication : password_authentication(params[:name], params[:password])
  end

#  def create
#    logout_keeping_session!
#    user = User.authenticate(params[:login], params[:password])
#    if user
#      # Protects against session fixation attacks, causes request forgery
#      # protection if user resubmits an earlier form using back
#      # button. Uncomment if you understand the tradeoffs.
#      # reset_session
#      user.update_visited_at
#      self.current_user = user
#      new_cookie_flag = (params[:remember_me] == "1")
#      handle_remember_cookie! new_cookie_flag
#      flash[:notice] = "Logged in successfully"
#      redirect_back_or_default(user.has_role?('admin') ? admin_root_path : root_path)
#    else
#      note_failed_signin
#      @login       = params[:login]
#      @remember_me = params[:remember_me]
#      render :action => 'new'
#    end
#  end

  def destroy
    logout_killing_session!
    flash[:message] = "You have been logged out."
    redirect_back_or_default('/')
  end

  # ++++++++++++++++++++++++++++++ protected ++++++++++++++++++++++++++++++
  protected
  
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{ params[:login] }'"
    logger.warn "Failed login for '#{ params[:login] }' from #{request.remote_ip} at #{ Time.now.utc }"
  end

  def password_authentication(name, password)
    if @user = User.authenticate(params[:login], params[:password])
      successful_login
    else
      failed_login "Sorry, that username/password doesn't work"
    end
  end

  def open_id_authentication
    authenticate_with_open_id do |result, identity_url|
      if result.successful?
        if @user = User.find_by_identity_url(identity_url)
          successful_login
        else
          failed_login "Sorry, no user by that identity URL exists (#{ identity_url })"
        end
      else
        failed_login result.message
      end
    end
  end

  # ------------------------------ private --------------------------------
  private

  def successful_login
    # It's possible to use OpenID only, in which
    # case the following would update a user's email and nickname
    # on login. 
    #
    # This may give conflicts when used in combination with regular
    # user accounts.
    #
    # TODO: Add a configuration option to disable regular accounts.
    #
    # current_user.update_attributes(
    #   :login => "#{params[:openid.sreg.nickname]}",
    #   :email => "#{params[:openid.sreg.email]}"
    # )
    @user.update_visited_at
    self.current_user = @user
    new_cookie_flag = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag
    flash[:message] = "Logged in successfully"
    redirect_back_or_default(@user.has_role?('admin') ? admin_root_path : root_path)
  end

  def failed_login(message)
    flash[:error] = message
    redirect_to(login_path)
  end

end
