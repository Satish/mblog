module PrivateMessagesHelper
  
  def receiver_options_for_select
    current_user.followers.active.collect{ |follower| [follower.login, follower.id] }
  end
  
end
