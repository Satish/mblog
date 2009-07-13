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

require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
