# == Schema Information
#
# Table name: notifications
#
#  id                          :integer(4)      not null, primary key
#  email_on_new_follower       :boolean(1)
#  email_on_new_direct_message :boolean(1)
#  email_on_new_reply          :boolean(1)
#  email_newsletter            :boolean(1)      default(TRUE)
#  email_updates               :boolean(1)      default(TRUE)
#  user_id                     :integer(4)
#  created_at                  :datetime
#  updated_at                  :datetime
#

class Notification < ActiveRecord::Base

  validates_presence_of :user_id
  validates_uniqueness_of :user_id

  belongs_to :user

end
