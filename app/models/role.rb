# == Schema Information
#
# Table name: roles
#
#  id    :integer(4)      not null, primary key
#  name  :string(255)
#  state :boolean(1)      default(TRUE)
#

class Role < ActiveRecord::Base
  
  @@per_page = 10
  cattr_reader :per_page
  attr_accessible :name

  named_scope :active, :conditions => { :active => true }

  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :roles_users, :dependent => :destroy
  has_many :users, :through => :roles_users

end
