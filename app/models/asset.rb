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

class Asset < ActiveRecord::Base

  THUMBNAILS = { :S50x50 => "50x50", :S150x150 => "150x150", :S350x350 => "350x350" }
    
  validates_presence_of :owner_id, :attachable_id, :attachable_type
  
  has_attachment :content_type => [ :image,
                                    'application/msword',
                                    'application/pdf',
                                    'application/vnd.ms-excel',
                                    'text/plain',
                                    'application/vnd.ms-powerpoint'],
                 :thumbnails => THUMBNAILS,
                 :storage => RAILS_ENV == "production" ? :s3 : :file_system

  validates_as_attachment

  belongs_to :attachable, :polymorphic => true
  belongs_to :owner, :class_name=>'User'

end