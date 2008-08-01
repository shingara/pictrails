class TagsController < ApplicationController

  caches_page :show
  
  def show
    @tag = Tag.find_by_name params[:id]
    @tags = [@tag]
    @taggings = @tag.taggings.paginate :page => params[:page],
      :per_page => this_webapp.pictures_pagination
  end

end
