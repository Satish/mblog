class MessagesController < ApplicationController

  before_filter :login_required, :except => [:index]
  before_filter :find_user, :except => [:index]
  before_filter :find_message, :only => [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.xml
  def index
    options = { :page => params[:page], :include => [:owner] }
    @message = Message.new(:body => '')
    @messages = logged_in? ? current_user.owned_messages.search(params[:query], options) : Message.search(params[:query], options)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

#  # GET /messages/1
#  # GET /messages/1.xml
#  def show
#    @message = Message.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @message }
#    end
#  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit; end

  # POST /messages
  # POST /messages.xml
  def create
    @message = current_user.owned_messages.new(params[:message])
    @message.attachable = @user
    if request.format.xml? || request.format.json?
      respond_to do |format|
        if @message.save
          format.xml  { render :xml => @message.to_xml(:only => ["id", "owner_id", "parent_id", "attachable_id", "attachable_type", "body", "created_at"], :methods => []), :status => :created }
          format.json { render :json => custom_to_json([@message], :attrs => ["id", "owner_id", "parent_id", "attachable_id", "attachable_type", "body", "created_at"], :methods => []), :status => :created }
        else
          format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
          format.json { render :json => @message.errors, :status => :unprocessable_entity }
        end
      end
    else
      responds_to_parent do
        respond_to do |format|
          format.js
        end
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        flash[:notice] = 'Message was successfully updated.'
        format.html { redirect_to(@message) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end

  #----------------------------------- private -----------------------------
  private

  def find_user
    @user = User.find_by_login(params[:user_id])
    redirect_to_root_path_with_error_message unless @user
  end

  def find_message
    @message = current_user.owned_message.find_by_id(params[:id])
    redirect_to_root_path_with_error_message unless @message
  end

end
