# == Schema Information
#
# Table name: message_users
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  message_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class MessageUserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
