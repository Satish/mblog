class InvitationMailer < ActionMailer::Base
  
  def invitation_email(invitation)
    subject        "Join #{ invitation.sender.name } on #{ SITE }"
    recipients     invitation.email
    from           invitation.sender.email
    sent_on        Time.zone.now
    body           :sender => invitation.sender, :receiver => invitation.email, :url => invitation_url(:invitation_code => invitation.invitation_code, :host => SITE_NAME)
    content_type   "text/html"
  end

end
