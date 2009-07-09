class MessageUser < ActiveRecord::Base

  validates_presence_of :message_id, :user_id
  validates_uniqueness_of :message_id, :scope => [:user_id]

  belongs_to :message
  belongs_to :user

  after_create :increment_message_counters
  before_destroy :decrement_message_counter
  
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~ protected ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  protected

  def increment_message_counters
    user.increment!(:addressed_messages_count)
  end

  def decrement_message_counter
    self.user.decrement!(:addressed_messages_count)
  end


end
