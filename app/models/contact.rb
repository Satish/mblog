class Contact < ActiveRecord::Base

  validates_presence_of :following_id, :follower_id
  validates_uniqueness_of :follower_id, :scope => [:following_id]

  belongs_to :following, :class_name => 'User'
  belongs_to :follower, :class_name => 'User'

  protected

  def validate
    if follower_id == following_id
      errors.add_to_base("You can't follow yourself!")
    end
  end

end
