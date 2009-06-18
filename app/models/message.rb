# == Schema Information
#
# Table name: messages
#
#  id              :integer(4)      not null, primary key
#  body            :text
#  parent_id       :integer(4)
#  owner_id        :integer(4)
#  lft             :integer(4)
#  rgt             :integer(4)
#  deleted_at      :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  attachable_id   :integer(4)
#  attachable_type :string(255)
#

class Message < ActiveRecord::Base

  acts_as_nested_set :dependent => :destroy

  validates_presence_of :body, :owner_id, :attachable_id, :attachable_type
  validates_length_of :body, :maximum => MAX_MESSAGE_LENGTH

  belongs_to :owner, :class_name => 'User'
  belongs_to :attachable, :polymorphic => true

  def owner?(user)
    owner == user
  end

#  has_many :message_users, :dependent => :destroy

end
