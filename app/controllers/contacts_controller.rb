class ContactsController < ApplicationController

  before_filter :login_required
  before_filter :find_user

  def index
    default_options = { :page => params[:page], :per_page => 20 }
    @contacts = get_contacts(default_options)
    respond_to do |format|
      format.html { render :action => "index" }
      format.xml { render :xml => @contacts.to_xml(:only => ["id", "login", "name", "bio", "location", "portfolio", "resume", "skills", "contacts_count", "kudo_points", "created_at"], :methods => [:profile_pic_path]) }
      format.json { render :json => custom_to_json(@contacts, :attrs => ["id", "login", "name", "bio", "location", "portfolio", "resume", "skills", "contacts_count", "kudo_points", "created_at"], :methods => :profile_pic_path) }
      format.rss { render_rss_feed_for(@contacts, :feed => { :title => "Contacts", :description => params[:user_id]+"'s "+params[:contact], :link => HOST+'/'+params[:user_id]+'/'+params[:contact] }, :item => ResourceFeederItemHash) }
    end
  end

  def create
    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { }
    end
  end

  def remove
    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { }
    end
  end

  #------------------------- private ----------------------------
  private

  def find_user
    @user = User.active.find_by_login(params[:user_id])
      unless @user
      respond_to do |format|
        format.html { flash[:error] = PAGE_NOT_FOUND and redirect_to user_contacts_path(current_user, :id => params[:id] || 'followers') and return }
        format.js { render :nothing => true }
        format.xml  { }
      end
    end
  end

  def get_contacts(default_options)
    case params[:id]
    when 'followers'
      return @user.followers.search(params[:query], default_options)
    when 'followings'
      return @user.followings.search(params[:query], default_options)
    else
      redirect_to user_contacts_path(current_user, :id => params[:id] || 'followers') and return unless @user
    end
  end

end
