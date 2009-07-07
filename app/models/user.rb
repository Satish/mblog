# == Schema Information
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  login                     :string(40)
#  name                      :string(100)     default("")
#  email                     :string(100)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(40)
#  remember_token_expires_at :datetime
#  activation_code           :string(40)
#  activated_at              :datetime
#  state                     :string(255)     default("passive")
#  deleted_at                :datetime
#
# Indexes
#
#  index_users_on_login  (login) UNIQUE
#

require 'digest/sha1'

class User < ActiveRecord::Base
 
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles

  named_scope :active, :conditions => { :state => 'active' }
  named_scope :pending, :conditions => { :state => 'pending' }
  named_scope :deleted, :conditions => { :state => 'deleted' }
  named_scope :suspended, :conditions => { :state => 'suspended' }

  validates_presence_of     :login,    :case_sensitive => false
  validates_length_of       :login,    :within => 3..40, :if => Proc.new{ |user| true unless user.login.blank? }
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100, :if => Proc.new{ |user| true unless user.email.blank? } #r@a.wk
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message, :if => Proc.new{ |user| true unless user.email.blank? }

  has_many :roles_users, :dependent => :destroy
  has_many :roles, :through => :roles_users

  has_many :contact_followers, :class_name => 'Contact', :foreign_key => 'following_id', :dependent => :destroy
  has_many :followers, :through => :contact_followers, :source => :follower

  has_many :contact_followings, :class_name => 'Contact', :foreign_key => 'follower_id', :dependent => :destroy
  has_many :followings, :through => :contact_followings, :source => :following

  has_many :owned_messages, :class_name => 'Message', :foreign_key => 'owner_id', :dependent => :destroy
  has_many :attached_messages, :class_name => 'Message', :as => :attachable

  has_one :profile_image, :as => :attachable, :dependent => :destroy

#  has_many :assets, :as => :attachable, :dependent => :destroy
#  has_one :notification, :dependent => :destroy


  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => {:login => login.downcase} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def update_visited_at
    self.update_attribute(:visited_at, Time.now.utc)
  end
  
  # has_role? simply needs to return true or false whether a user has a role or not.  
  # It may be a good idea to have "admin" roles return true always
  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    return true if @_list.include?("admin")
    (@_list.include?(role_in_question.to_s) )
  end

  def self.search(query, options)
    conditions = ["name like ? or login like ? or email like ?", "%#{query}%", "%#{query}%", "%#{query}%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "created_at DESC, login"}
    
    paginate default_options.merge(options)
  end

  def to_param
    login
  end

  def following?(user)
    user ? following_ids.include?(user.id) : false
  end

  def destroy_contact_following(user)
    contact_followings.find_by_following_id(user.id).destroy rescue nil
  end

  def name_or_login
    name.blank? ? login : name
  end
  
  # ++++++++++++++++++++++++++++++ protected ++++++++++++++++++++++++++++++
  protected

  def make_activation_code
    self.deleted_at = nil
    self.activation_code = self.class.make_token
  end

end
