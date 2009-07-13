class PrivateMessagesController < ApplicationController

  before_filter :login_required
  after_filter :mark_read_messages_as_unread, :only=> [:inbox]

  def index
    @private_message  = PrivateMessage.new(:message => '')
    @private_messages = current_user.inbox_messages.paginate(:page=> params[:page], :include=> [:sender, :receiver])
    @user = current_user

    respond_to do |format|
      format.html
      format.xml { render :xml => @private_messages }
      format.rss { render_rss_feed_for(@private_messages, :feed => { :title => "#{ @user.login }'s Inbox", :description => "#{ @user.login }'s private messages - received.", :link => HOST + '/inbox' }, :item => ResourceFeederItemHash) }
    end
  end

  def outbox
    @private_message  = PrivateMessage.new(:receiver_id=> params[:receiver])
    @private_messages = current_user.outbox_messages.paginate(:page=> params[:page], :include=> [:sender, :receiver])
    @user = current_user

    respond_to do |format|
      format.html
      format.json { render :json => @private_messages }
      format.rss { render_rss_feed_for(@private_messages, :feed => { :title => "#{ @user.login }'s Outbox", :description => "# {@user.login }'s private messages - sent.", :link => HOST + '/outbox' }, :item => ResourceFeederItemHash.merge(:link => :alt_link)) }
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
      format.js
      if @private_message
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
