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

require 'test_helper'

class RolesUserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
