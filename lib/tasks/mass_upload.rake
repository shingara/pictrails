namespace :pictrails do

  desc 'Import a directory in pictrails. Create gallery with this directory'
  task :import => [:environment] do
    puts 'You need define a directory with DIR variable' if ENV['DIR'].empty?
    Gallery.create_from_directory(ENV['DIR'].dup, true)
    include Pictrails::MassUpload
    while not upload_file(true).empty?
      upload_file(true)
    end
    print "\n"
  end
end
