# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'ruby-audio'
  s.version     = '1.6.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Stephen Augenstein']
  s.email       = ['perl.programmer@gmail.com']
  s.homepage    = 'http://github.com/warhammerkid/ruby-audio'
  s.summary     = 'libsndfile wrapper for ruby'
  s.description = 'ruby-audio wraps around libsndfile to provide simplified sound reading and writing support to ruby programs'

  s.files         = Dir['ruby-audio.gemspec', 'README.rdoc', 'LICENSE', 'Rakefile', 'lib/**/*.rb', 'spec/**/*.{rb,opts,wav,mp3}', 'ext/**/*.{c,h,rb}']
  s.test_files    = Dir['spec/**/*_spec.rb']
  s.extensions    = Dir["ext/**/extconf.rb"]

  s.requirements << 'libsndfile (http://www.mega-nerd.com/libsndfile/)'

  s.extra_rdoc_files = Dir['README.rdoc', 'ext/**/*.c']
  s.rdoc_options     = ['--line-numbers', '--main', 'README.rdoc']
end
