module Admin::BaseHelper

  # Define the title of page in Administration
  def page_title_admin
    return "Pictrails - Administration - #{@page_title}" if @page_title
    return 'Pictrails - Administration'
  end

  # return 'current' string if the controller name is galleries
  def class_galleries
    if controller.controller_name == 'galleries'
      "current"
    end
  end
  
  # return 'current' string if the controller name is pictures
  def class_pictures
    if controller.controller_name == 'pictures'
      "current"
    end
  end

  # return 'current' string if the controller name is settings
  def class_settings
    if controller.controller_name == 'settings'
      "current"
    end
  end
  
  # return 'current' string if the controller name is comments
  def class_comments
    if controller.controller_name == 'comments'
      "current"
    end
  end
end
