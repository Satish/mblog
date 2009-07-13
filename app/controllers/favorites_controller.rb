class FavoritesController < ApplicationController

  before_filter :login_required, :except => [:index]
  before_filter :find_user, :only => [:index]
  before_filter :find_message, :except => [:index]

  def index
    @attachable = @user
    @message = current_user.owned_messages.new
        
    contitions = { :page => params[:page] }
    @messages = @user.favorite_messages.search(params[:query], contitions)
    respond_to do |format|
      format.html { render :action => "index" }
      format.xml { render :xml => @messages.to_xml(:only => ["id", "owner_id", "parent_id", "target_id", "target_type", "kudoed", "kudoable", "body", "created_at"], :methods => [:owner_username, :owner_profile_pic_path]) }
      format.rss { render_rss_feed_for(@messages, :feed => { :title => "#{@user.login}'s Favorites", :description => "#{@user.login}'s favorite posts.", :link => HOST+'/'+@user.login+'/favorites' }, :item => ResourceFeederItemHash) }
    end
  end

  def create
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def destroy
    @favorite = current_user.favorites.find_by_message_id(@message.id)
    unless @favorite
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { page.alert(UN_PROCESSED_REQUEST) }
      end
    end
  end

  private ########################

  def find_user
    @user = User.find_by_login(params[:user_id])
    redirect_to root_path and return unless @user
  end

  def find_message
    @message = Message.active.find_by_id(params[:id])
    unless @message
      respond_to do |format|
        format.js do
          render :update do |page|
            page.alert(UN_PROCESSED_REQUEST)
          end
        end
      end
    end
  end

end
