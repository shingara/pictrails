module PicturesHelper

  def tag_link(tag_list)
    list = ''
    tag_list.each { |tag|
      list += link_to tag, { :controller => "tags", :action => "show", :id => tag }
      list += " "
    }
    list
  end

end
