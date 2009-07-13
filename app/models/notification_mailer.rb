class NotificationMailer < ActionMailer::Base
  
  def email_on_new_follower(receiver, sender)
    setup_email(receiver, sender)
    @subject     += "#{ sender.name } is now following you on #{ SITE }."
    body         :sender => sender, :receiver => receiver
  end

  def email_on_new_direct_message(receiver, sender, private_message)
    setup_email(receiver, sender)
    @subject     += "Private message from #{ sender.name }"
    body         :sender => sender, :receiver => receiver, :private_message => private_message
  end

  def email_on_new_reply(receiver, sender, message)
    setup_email(receiver, sender)
    @subject        += "#{ sender.name } replied to your post"
    body           :sender => sender, :receiver => receiver, :message => message
  end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ protected ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  protected

  def setup_email(receiver, sender)
    @subject      = "[#{ SITE_NAME }] "
    @recipients   = receiver.email
    @from         = ADMIN_EMAIL
    @sent_on      = Time.zone.now
    @content_type = 'text/html'
  end

end
