class GalleriesController < ApplicationController

  caches_page :index, :show
  
  def index
    @galleries = Gallery.paginate_by_status_and_parent_id true, nil,
      :include => 'pictures', 
      :page => params[:page],
      :per_page => this_webapp.galleries_pagination
    @tags = Picture.tag_counts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @galleries }
    end
  end

  def show
    @gallery = Gallery.find_by_permalink(params[:id]) 
    raise ActiveRecord::RecordNotFound if @gallery.nil?
    unless  @gallery.status
      redirect_to galleries_url
    else
      @breadcrumb = @gallery
      @tags = @gallery.tag_counts
      @sub_content = @gallery.children.paginate_by_status(true, 
                                                          :page => params[:page],
                                                          :per_page => this_webapp.pictures_pagination,
                                                          :total_entries => (@gallery.nb_content))
      if @sub_content.size < this_webapp.pictures_pagination.to_i
        params[:page] = 1 if params[:page].nil?
        page = params[:page].to_i - (@sub_content.size / this_webapp.pictures_pagination.to_i)
        per_page = this_webapp.pictures_pagination.to_i - @sub_content.size
        if @sub_content.empty?
          @sub_content.replace(@sub_content + 
                               @gallery.pictures.paginate_by_status(true,
                                                                    :page => (page),
                                                                    :per_page => per_page,
                                                                    :shift => @gallery.diff_paginate)) 
        else
          @sub_content.replace(@sub_content + 
                               @gallery.pictures.paginate_by_status(true,
                                                                    :page => page,
                                                                    :per_page => per_page)) 
        end
      end

      respond_to do |format|
        format.html 
        format.xml  { render :xml => @gallery }
        format.atom
      end
    end
  rescue ActiveRecord::RecordNotFound
    render :status => 404
  end

end
