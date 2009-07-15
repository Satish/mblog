# == Schema Information
#
# Table name: private_messages
#
#  id               :integer(4)      not null, primary key
#  message          :text
#  sender_id        :integer(4)
#  receiver_id      :integer(4)
#  parent_id        :integer(4)
#  sender_deleted   :boolean(1)
#  receiver_deleted :boolean(1)
#  read             :boolean(1)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class PrivateMessageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
