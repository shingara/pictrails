RUBYFORGE_USERNAME = 'shingara'
RUBYFORGE_PROJECT = 'pictrails'
namespace :pictrails do
  namespace :website do
    desc 'Generate website files'
    task :generate do
      sh %{ ruby script/txt2html README.txt > website/index.html}
    end

    desc 'Upload website files to rubyforge'
    task :upload do
      host = "#{RUBYFORGE_USERNAME}@rubyforge.org"
      remote_dir = "/var/www/gforge-projects/#{RUBYFORGE_PROJECT}/"
      local_dir = 'website'
      sh %{rsync -aCv #{local_dir}/ #{host}:#{remote_dir}}
    end

    desc 'Publish the rdoc in rubyforge site'
    task :publish_docs => ['doc:clobber_app', 'doc:app']do
      host = "#{RUBYFORGE_USERNAME}@rubyforge.org"
      remote_dir = "/var/www/gforge-projects/#{RUBYFORGE_PROJECT}/rdoc"
      local_dir = 'doc'
      sh %{rsync -aCV #{local_dir}/ #{host}:#{remote_dir}}
    end

    desc 'Generate and upload website files'
    task :all => [:generate, :upload, :publish_docs]
  end
end
