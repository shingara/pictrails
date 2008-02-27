module Admin::BaseHelper

  # Define the title of page in Administration
  def page_title_admin
    return "Pictrails - Administration - #{@page_title}" if @page_title
    return 'Pictrails - Administration'
  end

  def class_galleries
    if controller.controller_name == 'galleries'
      "current"
    end
  end
  
  def class_pictures
    if controller.controller_name == 'pictures'
      "current"
    end
  end

  def class_settings
    if controller.controller_name == 'settings'
      "current"
    end
  end
end
