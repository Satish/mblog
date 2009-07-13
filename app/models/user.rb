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

  attr_accessor :current_password, :new_password, :new_password_confirmation, :password_update

  validates_presence_of     :login,    :case_sensitive => false#, :if => :not_using_openid?
  validates_length_of       :login,    :within => 3..40, :if => Proc.new{ |user| true unless user.login.blank? } and :not_using_openid?
  validates_uniqueness_of   :login,    :case_sensitive => false#, :if => :not_using_openid?
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message#, :if => :not_using_openid?

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100, :if => Proc.new{ |user| true unless user.email.blank? } #r@a.wk
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message, :if => Proc.new{ |user| true unless user.email.blank? }

  validates_presence_of     :current_password, :new_password, :new_password_confirmation, :if => :password_update?
  validates_confirmation_of :new_password, :new_password_confirmation, :if => :password_update?

  validates_uniqueness_of :identity_url, :unless => :not_using_openid?
  validate :normalize_identity_url

  has_many :roles_users, :dependent => :destroy
  has_many :roles, :through => :roles_users

  has_many :contact_followers, :class_name => 'Contact', :foreign_key => 'following_id', :dependent => :destroy
  has_many :followers, :through => :contact_followers, :source => :follower

  has_many :contact_followings, :class_name => 'Contact', :foreign_key => 'follower_id', :dependent => :destroy
  has_many :followings, :through => :contact_followings, :source => :following

  has_many :owned_messages, :class_name => 'Message', :foreign_key => 'owner_id', :dependent => :destroy
  has_many :attached_messages, :class_name => 'Message', :as => :attachable

  has_many :message_users, :dependent => :destroy
  has_many :addressed_messages, :through => :message_users, :source => :message

  has_one :profile_image, :as => :attachable, :dependent => :destroy
  has_one :notification, :dependent => :destroy

  has_many :favorites, :dependent => :destroy
  has_many :favorite_messages, :through => :favorites, :source => :message

  has_many :inbox_messages, :class_name=> 'PrivateMessage', :foreign_key => 'receiver_id', :conditions => "receiver_deleted=0"
  has_many :outbox_messages, :class_name=> 'PrivateMessage', :foreign_key => 'sender_id', :conditions => "sender_deleted=0"

#  has_many :assets, :as => :attachable, :dependent => :destroy

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :location, :url, :timezone, :lang, :bio, :current_password, :new_password, :new_password_confirmation


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

  def update_password(user_attr)
    self.attributes = user_attr
    self.valid?
    errors.add(:current_password, "is invalid") unless authenticated?(current_password)
    update_attributes( :password => new_password, :password_confirmation => new_password_confirmation  ) if errors.empty?
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

  def followed_by?(follower_id)
    follower_ids.include?(follower_id)
  end

  def destroy_contact_following(user)
    contact_followings.find_by_following_id(user.id).destroy rescue nil
  end

  def name_or_login
    name.blank? ? login : name
  end
  
  def paginate_and_search_dashboard_messages(query, options)
#    options.merge(:order => 'created_at DESC')
    sql = "SELECT messages.* from messages WHERE ("
    sql << "messages.deleted_at is NULL"
    sql << "AND messages.body like '%#{ query }%'" unless query.blank?
    sql <<  ") AND (messages.owner_id = #{ self.id } OR (messages.attachable_type = 'User' AND messages.attachable_id = #{ self.id })"
    sql << " OR messages.owner_id IN (#{ self.following_ids.join(',') })" unless self.following_ids.blank?
    sql << ") UNION SELECT messages.* FROM messages JOIN message_users on (message_users.message_id = messages.id AND message_users.user_id = #{ self.id })"
    sql << "ORDER BY created_at DESC"
    Message.paginate_by_sql(sql, options)
  end

  def paginate_and_search_profile_messages(query, options)
    sql = "SELECT messages.* from messages WHERE ("
    sql << "messages.deleted_at is NULL"
    sql << "AND messages.body like '%#{ query }%'" unless query.blank?
    sql <<  ") AND messages.owner_id = #{ self.id }"
#    sql << " OR messages.owner_id IN (#{ self.following_ids.join(',') })" unless self.following_ids.blank?
    sql << " UNION SELECT messages.* FROM messages JOIN message_users on (message_users.message_id = messages.id AND message_users.user_id = #{ self.id })"
    sql << " ORDER BY created_at DESC"
    Message.paginate_by_sql(sql, options)
  end


  def unique_identifier
    "@" + self.login
  end

  # ++++++++++++++++++++++++++++++ protected ++++++++++++++++++++++++++++++
  protected

  def make_activation_code
    self.deleted_at = nil
    self.activation_code = self.class.make_token
  end

  def not_using_openid?
    identity_url.blank?
  end

  def password_update?
    password_update
  end

  def password_required?
    new_record? ? not_using_openid? && (crypted_password.blank? || !password.blank?) : !password.blank?
  end

  def normalize_identity_url
    self.identity_url = OpenIdAuthentication.normalize_identifier(identity_url) unless identity_url.blank?
  rescue URI::InvalidURIError
    errors.add_to_base("Invalid OpenID URL")
  end

end
