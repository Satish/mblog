class PrivateMessage < ActiveRecord::Base

  cattr_reader :per_page
  @@per_page = 10

  default_scope :order => "private_messages.created_at DESC"  
  named_scope :unread, :conditions => {:read => false}

  validates_presence_of :receiver, :sender, :message

  belongs_to :sender, :class_name=> 'User'
  belongs_to :receiver, :class_name=> 'User'

  after_create :deliver_notification, :increment_private_messages_count
  after_destroy :decrement_private_messages_count

  def validate
    unless sender.followers.find_by_id(receiver_id)
      self.errors.add_to_base("You can only send messages to users who are following you")
    end if sender
  end

  def unread_for?(user)
    receiver == user and !read?
  end

  def received_by?(user)
    receiver.id == user.id
  end

  def self.mark_as_deleted(message_id, user, is_receiver)
    message = (user.inbox_messages.find_by_id(message_id) || user.outbox_messages.find_by_id(message_id))
    if message && (message.receiver_id == user.id)
      message.update_attribute(:receiver_deleted, true)
    elsif message && (message.sender_id == user.id)
      message.update_attribute(:sender_deleted, true)
    end
    message
  end

  def title
    self.message.length > 50 ? self.message[0..47] + "..." : self.message
  end

  def description
    self.message
  end

  def link
    HOST+'/inbox'
  end

  def alt_link
    HOST+'/outbox'
  end

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~ protected ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  protected

  def increment_private_messages_count
    receiver.increment!(:private_messages_count)
  end

  def decrement_private_messages_count
    receiver.decrement!(:private_messages_count)
  end

  def deliver_notification
    NotificationMailer.deliver_email_on_new_direct_message(receiver, sender, self) if self.receiver.notification.email_on_new_direct_message && self.receiver.active?
  end

end
