class UserMailer < ActionMailer::Base

  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = activate_url(:activation_code => user.activation_code, :host => SITE_NAME)
  end

  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = login_url( :host => SITE_NAME )
  end

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~ protected ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  protected

  def setup_email(user)
    @recipients  = user.email
    @from        = ADMIN_EMAIL
    @subject     = "[#{ SITE }] "
    @sent_on     = Time.now
    @body[:user] = user
  end

end
