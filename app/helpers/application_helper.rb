# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Return the status of a boolean
  def status_value(status)
    if status
      "Active"
    else
      "Disabled"
    end
  end

  # Define the title of page
  def page_title
    return "#{this_webapp.webapp_name} - #{@page_title}" if @page_title
    return "#{this_webapp.webapp_name}"
  end

  # Display the notice in class Notice in paragraph if there are one
  def flash_notice
    return '' unless flash[:notice]
    content_tag 'p', :class => 'notice' do 
      flash[:notice]
    end
  end

  # See a breadcrumbs in page of gallery
  def breadcrumbs(gallery=nil)
    breadcrumbs = link_to this_webapp.webapp_name, root_path
    unless gallery.nil?
      breadcrumbs += " > "
      breadcrumbs += parent_breadcrumbs_gallery(gallery)
    end
    breadcrumbs
  end

  # Generate the parent breadcrumb with recusive
  def parent_breadcrumbs_gallery(gallery)
    breadcrumbs = ""
    unless gallery.parent.nil?
      breadcrumbs += parent_breadcrumbs_gallery(gallery.parent)
      breadcrumbs += " > "
    end
    breadcrumbs += link_to gallery.name, gallery_path(gallery)
  end
end
