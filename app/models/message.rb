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
  default_scope :order => "created_at DESC"

  #attr_accessible :body

  validates_presence_of :body, :owner_id, :attachable_id, :attachable_type
  validates_length_of :body, :maximum => MAX_MESSAGE_LENGTH

  belongs_to :owner, :class_name => 'User'
  belongs_to :attachable, :polymorphic => true

  after_create :increment_messages_count
  after_destroy :decrement_messages_count

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
#  has_many :message_users, :dependent => :destroy

    def increment_messages_count
    owner.increment!(:owned_messages_count)
    attachable.increment!(:attached_messages_count)
  end

  def decrement_messages_count
    owner.decrement!(:owned_messages_count)
    attachable.decrement!(:attached_messages_count)
  end

end
