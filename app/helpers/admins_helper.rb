module AdminsHelper

  def gravatar_for(admin, options = { :size => 50 })
    gravatar_image_tag(admin.email.downcase, :alt => admin.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
end
