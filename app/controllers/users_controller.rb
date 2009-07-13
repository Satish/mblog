class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :login_required, :except => [:new, :index, :create, :activate]
  before_filter :find_user, :only => [:show]
  
  def index
    options = { :page => parse_page_number(params[:page]), :per_page => 20 }
    @users = User.active.search( params[:query], options )
  end

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.register! if @user && @user.valid?
    success = @user && @user.valid?
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
#      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def update
    @status = current_user.update_attributes(params[:user])
    @success_message = "Profile Updated Successfully." if @status
    render_update
  end

  def update_password
    current_user.password_update = true
    @status = current_user.update_password(params[:user])
    @success_message = "Password Updated Successfully." and   current_user.current_password = current_user.password = current_user.password_confirmation = nil if @status
    render_update
  end

  def update_picture
    if params[:profile_image]
      if @profile_image = current_user.profile_image
        @status = @profile_image.update_attributes(:uploaded_data => params[:profile_image])
      else
        @profile_image = ProfileImage.new(:uploaded_data => params[:profile_image])
        @profile_image.owner = @profile_image.attachable = current_user
        @status = @profile_image.save
      end
    end
    @success_message = "Profile Image Updated Successfully." if @status
    render_update
  end

  def update_notices
    @status = current_user.notification.update_attributes( params[:notification])
    @success_message = "Notification updated successfully" if @status
    render_update
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def show
    @message = Message.new(:body => '')
    options = { :page => params[:page], :include => [:owner] }
#    @messages = @user.owned_messages.search(params[:query], options)
    @messages = @user.paginate_and_search_profile_messages(params[:query], options)
    @attachable = @user
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  # ++++++++++++++++++++++++++++++ protected ++++++++++++++++++++++++++++++
  protected

  def find_user
    @user = User.find_by_login(params[:id])
    redirect_to_root_path_with_error_message unless @user
  end

  def render_update
    responds_to_parent do
      respond_to do |format|
        format.js do
          @form_id = params[:form_id]
          render :action => 'update'
        end
      end
    end
  end

end
