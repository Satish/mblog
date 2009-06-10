class ProfileImage < Asset
  
  has_attachment :content_type => :image,
                 :thumbnails => THUMBNAILS,
                 :storage => RAILS_ENV == "production" ? :s3 : :file_system

end
