module AdminsHelper

  def gravatar_for(admin, options = { :size => 50 })
    gravatar_image_tag(admin.email.downcase, :alt => admin.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end

  def league_logo
    image_tag(current_admin.league_url, :alt => "Console", :class => "round", :width => "100")
  end  

end
