# == Schema Information
#
# Table name: messages
#
#  id              :integer(4)      not null, primary key
#  body            :text
#  parent_id       :integer(4)
#  owner_id        :integer(4)
#  lft             :integer(4)
#  rgt             :integer(4)
#  deleted_at      :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  attachable_id   :integer(4)
#  attachable_type :string(255)
#

class Message < ActiveRecord::Base

  acts_as_nested_set :dependent => :destroy

  @@per_page = 20
  cattr_reader :per_page

  attr_accessor :parent_node_id

  default_scope :order => "messages.created_at DESC"
  named_scope :active, :conditions => { :deleted_at => nil }
  named_scope :deleted, :conditions => { :deleted_at => !nil }

  validates_presence_of :body, :owner_id, :attachable_id, :attachable_type
  validates_length_of :body, :maximum => MAX_MESSAGE_LENGTH, :if => Proc.new { |m| m.body.gsub(/\r\n|\n\r|\n|\r/,"").length > MAX_MESSAGE_LENGTH }

  has_many :message_users, :dependent => :destroy
  has_many :addressed_users, :through => :message_users, :source => :user

  belongs_to :owner, :class_name => 'User', :include => [:profile_image]
  belongs_to :attachable, :polymorphic => true

  after_create :process_addressed_users, :assign_parent_to_message, :increment_message_counters, :deliver_notification
  before_destroy :decrement_message_counters


  def validate
    if parent_node_id
      @parent_node = Message.active.find_by_id(parent_node_id)
      errors.add_to_base("The message you are replying to may have been deleted by the owner!") unless @parent_node
    end
  end

  def owner?(user)
    owner == user
  end

  def deleted?
    !deleted_at.nil?
  end

  def self.search(query, options)
    conditions = ["body like ?", "%#{ query }%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "created_at DESC"}
    
    paginate default_options.merge(options)
  end

  def body_for_add_this
    body.gsub(/\r\n|\n\r|\n|\r/," ").gsub("'","\\\\'")
  end

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~ protected ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  protected

  def process_addressed_users
    body.scan(/@\w[\w\.\-_]+/).uniq.collect{ |u| u.gsub!(/^@/,'') }.each do |login|
      user = User.active.find_by_login(login)
      self.addressed_users << user if user
    end
  end

  def assign_parent_to_message
    if @parent_node
      self.move_to_child_of(@parent_node)
      self.update_attribute(:attachable, @parent_node.attachable)
      self.ancestors.each{ |a| a.update_attribute(:updated_at, Time.zone.now) }
    end
  end

  def increment_message_counters
    owner.increment!(:owned_messages_count)
    attachable.increment!(:attached_messages_count)
  end

  def decrement_message_counters
    owner.decrement!(:owned_messages_count)
    attachable.decrement!(:attached_messages_count)
  end

  def deliver_notification
    NotificationMailer.deliver_email_on_new_reply(root.owner, owner, self) if (!root? && root.owner.notification.email_on_new_reply && (owner != root.owner) && root.owner.active?)
  end

end
