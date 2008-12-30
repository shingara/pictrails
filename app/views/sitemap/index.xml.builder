xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.urlset "xmlns"=>"http://www.sitemaps.org/schemas/sitemap/0.9" do
  @galleries.each do |gallery|
    xml.tag! 'url' do
      xml.tag! 'loc', gallery_url(gallery)
      xml.tag! 'lastmod', gallery.updated_at.strftime("%Y-%m-%d")
      xml.tag! 'priority', '0.8'
    end
    gallery.pictures.each do |picture|
      xml.tag! 'url' do
        xml.tag! 'loc', gallery_picture_url(gallery, picture)
        xml.tag! 'lastmod', picture.updated_at.strftime("%Y-%m-%d")
        xml.tag! 'priority', '0.8'
      end
    end
  end
  @pictures.each do |picture|
    xml.tag! 'url' do
      xml.tag! 'loc', picture_url(picture)
      xml.tag! 'lastmod', picture.updated_at.strftime("%Y-%m-%d")
      xml.tag! 'priority', '0.8'
    end
  end

  @tags.each do |tag_picture|
    xml.tag! 'url' do
      xml.tag! 'loc', tag_url(tag_picture)
      xml.tag! 'lastmod', tag_picture.taggings.last.created_at.strftime("%Y-%m-%d")
      xml.tag! 'priority', '0.8'
    end
  end
end
