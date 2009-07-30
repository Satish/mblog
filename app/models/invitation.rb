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

class Invitation < ActiveRecord::Base

  include Authentication
  include Authorization::AasmRoles

  validates_presence_of     :email, :user_id, :invitation_code
  validates_uniqueness_of   :invitation_code
  validates_uniqueness_of   :email, :scope => :user_id
  validates_format_of       :email, :with => Authentication.email_regex, :message => Authentication.bad_email_message

  belongs_to :sender, :foreign_key => "user_id", :class_name => "User"

  before_validation_on_create :generate_invitaion_code
  after_create :deliver_invitation_email

  aasm_initial_state :initial => :pending
  aasm_state :pending
  aasm_state :accepted

  aasm_event :accept do
    transitions :from => [:pending], :to => :accepted
  end

 # ~~~~~~~~~~~~~~~~~~~~~~~~~~~ protected ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  protected

  def deliver_invitation_email
    InvitationMailer.deliver_invitation_email(self)
  end

  def generate_invitaion_code
    self.invitation_code = User.make_token
  end

end
