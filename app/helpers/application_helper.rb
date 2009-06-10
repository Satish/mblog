# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def profile_image(source, thumbnail, options = {})
    options = options.merge({:size => ProfileImage::THUMBNAILS[thumbnail]}) unless source.profile_image
    image_tag(profile_image_path(source, thumbnail), options)
  end

  def profile_image_path(source, thumbnail)
    source.profile_image ? source.profile_image.public_filename(thumbnail) : 'default_image.png'
  end

end
