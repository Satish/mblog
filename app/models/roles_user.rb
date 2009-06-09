# == Schema Information
#
# Table name: roles_users
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  role_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_roles_users_on_role_id  (role_id)
#  index_roles_users_on_user_id  (user_id)
#

class RolesUser < ActiveRecord::Base

  validates_presence_of :role_id, :user_id
  validates_uniqueness_of :role_id, :scope => :user_id
  
  belongs_to :role
  belongs_to :user

end
