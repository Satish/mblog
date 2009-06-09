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

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
