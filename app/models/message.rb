# == Schema Information
#
# Table name: messages
#
#  id         :integer(4)      not null, primary key
#  body       :text
#  parent_id  :integer(4)
#  owner_id   :integer(4)
#  lft        :integer(4)
#  rgt        :integer(4)
#  deleted_at :datetime
#  created_at :datetime
#  updated_at :datetime
#

class Message < ActiveRecord::Base

#  acts_as_nested_set :dependent => :destroy

  validates_presence_of :body, :owner_id

  belongs_to :owner, :class_name => 'User'
#  belongs_to :target, :polymorphic => true

#  has_many :message_users, :dependent => :destroy

end
