module EmailHelper
  def email_image_tag image, **options
    attachments[image] = File.read(Rails.root.join("app/assets/images/#{image}"))
    image_tag attachments[image].url, **options
  end

  def image_carrierwave_tag image, **options
    attachments[image.logo_identifier] =  File.read("#{Rails.root}/public#{image.logo.url}")
    image_tag attachments[image.logo_identifier].url, **options
  end
end
