# == Schema Information
#
# Table name: favorites
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  message_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Favorite < ActiveRecord::Base

  default_scope :order => "favorites.created_at DESC"

  validates_presence_of :user_id, :message_id
  validates_uniqueness_of :message_id, :scope => :user_id

  belongs_to :user
  belongs_to :message

  after_create :increment_favorite_messages_count
  after_destroy :decrement_favorite_messages_count

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~ protected ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  protected

  def increment_favorite_messages_count
    user.increment!(:favorite_messages_count)
  end

  def decrement_favorite_messages_count
    user.decrement!(:favorite_messages_count)
  end

end
