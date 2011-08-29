# Rake require fancy footwork is for bundler's benefit.
begin
  Rake
rescue NameError
  require 'rake'
end

Gem::Specification.new do |s|
  s.name = 'elephant-cache'
  s.version = '1.0.0'
  
  s.required_ruby_version = '>= 1.8.7'
  
  s.authors = ['Jeff Reinecke']
  s.email = 'jeff@paploo.net'
  s.homepage = 'http://www.github.com/paploo/elephant'
  
  s.require_paths = ['lib']
  s.licenses = ['BSD']
  s.files = FileList['README.rdoc', 'LICENSE.txt', 'Rakefile', 'lib/**/*', 'spec/**/*']
  
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc']
  
  s.summary = 'A simple object caching design pattern in a reusable module.'
  s.description = <<-DESC
    A simple object caching design pattern in a reusable module.
  DESC
end
