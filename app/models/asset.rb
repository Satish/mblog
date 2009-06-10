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
