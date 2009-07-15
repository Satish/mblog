# == Schema Information
#
# Table name: invitations
#
#  id              :integer(4)      not null, primary key
#  email           :string(100)
#  invitation_code :string(40)
#  state           :string(255)     default("pending")
#  user_id         :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
