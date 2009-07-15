class PrivateMessagesController < ApplicationController

  before_filter :login_required
#  after_filter :mark_read_messages_as_unread, :only=> [:inbox]

  def index
    conditions = { :page=> params[:page], :include=> [:sender, :receiver] }
    respond_to do |format|
      format.html do
        @private_message  = PrivateMessage.new(:message => '')
        @inbox_messages = current_user.inbox_messages.search(params[:query], conditions)
        @outbox_messages = current_user.outbox_messages.search(params[:query], conditions)
      end
      format.js do
        @inbox_messages = current_user.inbox_messages.search(params[:query], conditions) if params[:loc] == 'inbox'
        @outbox_messages = current_user.outbox_messages.search(params[:query], conditions) if params[:loc] == 'outbox'
        render :partial => 'private_messages', :locals => { :private_messages => @outbox_messages || @inbox_messages , :loc => params[:loc] } , :layout => false
      end
    end
  end

  # POST /private_messages
  # POST /private_messages.xml
  def create
    @user = current_user
    @private_message = current_user.outbox_messages.new(:receiver_id => params[:private_message][:receiver_id])
    @private_message.attributes = params[:private_message]
    @private_message.save
    responds_to_parent do
      respond_to do |format|
        format.js
      end
    end
  end

  # DELETE /private_messages/1
  # DELETE /private_messages/1.xml
  def destroy
    @private_message = PrivateMessage.mark_as_deleted(params[:id], current_user, params[:is_reader])

    respond_to do |format|
      if @private_message
        format.js do
          conditions = { :page=> params[:page], :include=> [:sender, :receiver] }
          @inbox_messages = current_user.inbox_messages.paginate(conditions) if params[:loc] == 'inbox'
          @outbox_messages = current_user.outbox_messages.paginate( conditions) if params[:loc] == 'outbox'
          render :partial => 'private_messages', :locals => { :private_messages => @outbox_messages || @inbox_messages , :loc => params[:loc] } , :layout => false
        end
        format.xml { render :xml => { :notice => "Private message deleted" }, :status => :ok }
        format.json { render :json => { :notice => "Private message deleted" }, :status => :ok }
      else
        raise ActiveRecord::RecordNotFound
      end
    end
  end

  #------------------------- private ----------------------------
  private

  def mark_read_messages_as_unread
    message_ids = @private_messages.collect(&:id).join(',')
    PrivateMessage.update_all("private_messages.read=1", "id in (#{message_ids})") unless message_ids.blank?
  end

end
