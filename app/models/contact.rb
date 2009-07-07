# == Schema Information
#
# Table name: contacts
#
#  id           :integer(4)      not null, primary key
#  follower_id  :integer(4)
#  following_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class Contact < ActiveRecord::Base

  validates_presence_of :following_id, :follower_id
  validates_uniqueness_of :follower_id, :scope => [:following_id]

  belongs_to :following, :class_name => 'User'
  belongs_to :follower, :class_name => 'User'

  after_create :increment_contacts_count
  after_destroy :decrement_contacts_count

  protected

  def validate
    if follower_id == following_id
      errors.add_to_base("You can't follow yourself!")
    end
  end

  def increment_contacts_count
    follower.increment!(:followings_count)
    following.increment!(:followers_count)
  end

  def decrement_contacts_count
    follower.decrement!(:followings_count)
    following.decrement!(:followers_count)
  end


end
