module Admin::PicturesHelper
  def tasks
    output = []
    output << content_tag(:li, link_to("Show gallery #{@picture.gallery.name}", admin_gallery_url(@picture.gallery)))
    output << content_tag(:li, link_to("Edit gallery #{@picture.gallery.name}", edit_admin_gallery_url(@picture.gallery)))
    output << content_tag(:li, link_to("See Picture #{@picture.title}", admin_picture_url(@picture))) unless params[:action] == 'show'
    output << content_tag(:li, link_to("Edit Picture #{@picture.title}", edit_admin_picture_url(@picture))) unless params[:action] == 'edit'
    output << content_tag(:li, link_to("Copie Picture #{@picture.title} to other gallery", copy_admin_picture_url(@picture), :id => 'copy_picture')) unless params[:action] == 'copy'
    output << content_tag(:li, link_to("Delete picture", destroy_picture_url(@picture), :method => 'delete', :confirm => 'Are you sure ?'))
    content_for(:tasks) { output.join("\n") }
  end

  def copy_admin_picture_url(picture)
    {:controller => 'admin/pictures', :action => 'copy', :gallery_id => picture.gallery.permalink, :picture_id => picture.permalink}
  end

  def destroy_picture_url(picture)
    {:controller => 'admin/pictures', :action => 'destroy', :gallery_id => picture.gallery.permalink, :id => picture.permalink}
  end

end
