class InvitationsController < ApplicationController

  def index; end

  def create
    count, already_invited_emails = current_user.invite_from_emails(params[:emails])
    flash[:notice] = "We have invited #{ count } of your contacts successfully." + (already_invited_emails.empty? ? '' : " Already  invited contacts: #{ already_invited_emails.join(', ') }")
    redirect_to invitations_path
  end

end
