atom_feed(:url => formatted_galleries_url(:atom)) do |feed|
  feed.title("#{this_webapp.webapp_name} - #{@gallery.name}")
  feed.updated(@sub_content.first ? @sub_content.first.created_at : Time.now.utc)

  for picture in @sub_content
    feed.entry(picture) do |entry|
      entry.title(picture.title)
      entry.content("<p>#{User.first.login} has post a new photo :</p> <p>#{image_tag (picture.public_filename(:thumb))}</p>", 
          :type => 'html')

      entry.author do |author|
        author.name(User.first.login)
        author.email(User.first.email)
      end
    end
  end
end
