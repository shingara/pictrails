require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'lib/pictrails/version'

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

  end
end
