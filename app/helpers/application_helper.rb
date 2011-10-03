module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "Keas HR Console"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("logo.png", :alt => "Console", :class => "round", :width => "30")
  end  
  
end
