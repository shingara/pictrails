require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'lib/pictrails/version'
require 'rubyforge'
  
def paragraphs_of(path, *paragraphs)
  File.read(path).delete("\r").split(/\n\n+/).values_at(*paragraphs)
end

namespace :pictrails do
  namespace :release do
    desc 'Generate manifest'
    task :generate_manifest do
      require 'find'
      exclude = Regexp.union "tmp$", "\.svn", "\.git", 
        /config\/database.yml$/, /\.sqlite3$/, "website.rake$", 
        "release.rake$", /txt2html$/, "website", "pkg", /\.log/, 
        /^tmp\//, /^\.\/coverage\//, /^\.\/doc\//, 
        /deployment.rake$/, /^\.\/galleries\//, 
        /^\.\/public\/pictrails_pictures/, 
        /^\.\/public\/pictrails_thumbnails/, /^\.\/nbproject/, 
        /^\.\/tmp\//
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

    PKG_NAME = 'pictrails'
    PKG_VERSION = Pictrails::VERSION::STRING
    SUBJECT = "[ANN] pictrails #{PKG_VERSION} Released" 
    CHANGE = paragraphs_of('History.txt', 0..1) 
    DESCRIPTION = %(
Pictrails is a Web Photo Gallery, written with Rails 2.0. Pictrails can manage several photo galleries.

It's features are :

* Create several Galleries
* Add several pictures in a Gallery
* Create a gallery with define a directory in same server of pictrails
* Admin interface with login to add/edit/delete Galleries and Pictures
* Define the thumbnails and pictures size in settings interface
* Delete the cache page in settings interface
* Define the number of pictures by pagination Gallery
    )
    spec = Gem::Specification.new do |s|
      s.name = PKG_NAME
      s.version = PKG_VERSION
      s.summary = "A Web Photo Gallery, written with Rails 2.0. Pictrails can manage several photo galleries."
      s.has_rdoc = false
      
      s.files = File.read("Manifest.txt").delete("\r").split(/\n/)
      s.require_path = '.'
      s.author = "Cyril Mougel"
      s.email = "cyril.mougel@gmail.com"
      s.homepage = "http://pictrails.rubyforge.org"  
      s.rubyforge_project = "pictrails"
      s.platform = Gem::Platform::RUBY 
    end

    Rake::GemPackageTask.new spec do |pkg|
      pkg.need_tar = true
      pkg.need_zip = true
    end

    desc 'Upload package in rubyforge'
    task :upload_package do
      rf = RubyForge.new
      puts "Logging in Rubyforge"
      rf.login
      
      c = rf.userconfig
      c["release_notes"] = DESCRIPTION 
      c["release_changes"] = CHANGE
      c["preformatted"] = true

      pkg = "pkg/#{PKG_NAME}-#{PKG_VERSION}"

      files = [( "#{pkg}.tgz"),
               ("#{pkg}.zip")].compact

      puts "Releasing Pictrails v. #{PKG_VERSION}"
      rf.add_release PKG_NAME, PKG_NAME, PKG_VERSION, *files
    end

    desc 'generate annonce in email.txt'
    task :email do
      File.open("email.txt", "w") do |mail|
        mail.puts "pictrails version #{PKG_VERSION} has been released!"
        mail.puts
        mail.puts DESCRIPTION
        mail.puts
        mail.puts CHANGE
        mail.puts
      end
      puts "Created email.txt"
    end

    desc 'post annonce to rubyforge'
    task :post_rubyforge => [:email] do
      rf = RubyForge.new
      rf.login
      rf.post_news(PKG_NAME, SUBJECT, File.read('email.txt'))
      puts "Posted to rubyforge"
    end

  end
end
