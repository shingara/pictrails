namespace :pictrails do
  namespace :release do
    desc 'Generate manifest'
    task :generate_manifest do
      require 'find'
      exclude = Regexp.union "tmp$", "\.svn", "\.git", /config\/database.yml$/, /\.sqlite3$/, "website.rake$", "release.rake$", /txt2html$/, "website", "pkg", /\.log/, /^tmp\//, /^\.\/coverage\//, /^\.\/doc\//, /deployment.rake$/, /^\.\/galleries\//, /^\.\/public\/pictrails_pictures/, /^\.\/public\/pictrails_thumbnails/, /^\.\/nbproject/, /^\.\/tmp\//
      files = []
      Find.find '.' do |path|
        next unless File.file? path
        next if path =~ exclude
        files << path[2..-1]
      end
      files = files.sort.join "\n"
      File.open "Manifest.txt", 'w' do |fp| 
        fp.puts files 
      end
    end
  end
end
