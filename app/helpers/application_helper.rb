# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  include TagsHelper

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
  def breadcrumbs
    breadcrumbs = link_to this_webapp.webapp_name, root_path, :class => 'first-breadcrumb'
    unless @breadcrumb.nil?
      breadcrumbs += content_tag(:label, " > ")
      if @breadcrumb.kind_of? Picture
        picture = @breadcrumb
        @breadcrumb = @breadcrumb.gallery
      end
      breadcrumbs += parent_breadcrumbs_gallery(@breadcrumb)

      unless picture.nil?
        breadcrumbs += content_tag(:label, " > ")
        breadcrumbs += content_tag(:label, picture.title, :class => 'end-breadcrumb')
      end
    end
    if @finish_breadcrumb
      breadcrumbs + " > " + @finish_breadcrumb
    else
      breadcrumbs
    end
  end

  # Generate the parent breadcrumb with recusive
  def parent_breadcrumbs_gallery(gallery)
    breadcrumbs = ""
    unless gallery.parent.nil?
      breadcrumbs += parent_breadcrumbs_gallery(gallery.parent)
      breadcrumbs += content_tag(:label, " > ")
    end
    breadcrumbs += link_to(gallery.name, gallery_path(gallery),
      :class => (@breadcrumb == gallery ? 'end-breadcrumb' : 'middle-breadcrumb'))
  end

  # Get the link of Gallery with name and the number of picture in this
  # gallery
  def link_gallery_with_number(gallery)
    link_to "#{gallery.title} [#{gallery.pictures.count}]", gallery_path(gallery), :class => ('current_gallery' if gallery == @gallery)
  end

  # Generate the list by tree of Gallery in sidebar
  def tree_gallery(gallery)
    str = ""
    if @gallery == gallery || @gallery.ancestors.include?(gallery)
      str = "<ul>"
      gallery.children.each do |gallery_child|
        str += "<li>"
        str += link_gallery_with_number(gallery_child)
        str += tree_gallery(gallery_child)
        str += "</li>"
      end
      str += "</ul>"
    end
    str
  end

  def add_error_message
  end
end
