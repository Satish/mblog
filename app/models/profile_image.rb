# == Schema Information
#
# Table name: assets
#
#  id              :integer(4)      not null, primary key
#  filename        :string(255)
#  content_type    :string(255)
#  thumbnail       :string(255)
#  size            :integer(4)
#  width           :integer(4)
#  height          :integer(4)
#  parent_id       :integer(4)
#  owner_id        :integer(4)
#  attachable_id   :integer(4)
#  attachable_type :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class ProfileImage < Asset
  
  has_attachment :content_type => :image,
                 :thumbnails => THUMBNAILS,
                 :storage => RAILS_ENV == "production" ? :s3 : :file_system

end
