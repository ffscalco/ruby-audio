require 'rubygems'
require 'rake'
require 'rdoc/task'
require 'rubygems/package_task'
require 'rspec/core/rake_task'
require 'rake/extensiontask'
require 'rake/extensioncompiler'
require 'mini_portile'

desc 'Default: run the specs.'
task :default => :spec

# I don't want to depend on bundler, so we do it the bundler way without it
gemspec_path = 'ruby-audio.gemspec'
spec = begin
  eval(File.read(File.join(File.dirname(__FILE__), gemspec_path)), TOPLEVEL_BINDING, gemspec_path)
rescue LoadError => e
  original_line = e.backtrace.find { |line| line.include?(gemspec_path) }
  msg  = "There was a LoadError while evaluating #{gemspec_path}:\n  #{e.message}"
  msg << " from\n  #{original_line}" if original_line
  msg << "\n"
  puts msg
  exit
end

$recipes = {}
LIBSNDFILE_VERSION = '1.0.24'
$recipes[:libsndfile] = MiniPortile.new "libsndfile", LIBSNDFILE_VERSION
$recipes[:libsndfile].files << "http://www.mega-nerd.com/libsndfile/files/libsndfile-#{LIBSNDFILE_VERSION}.tar.gz"
# p Rake::ExtensionCompiler.methods
# $recipes.each { |_, recipe| recipe.host = Rake::ExtensionCompiler.mingw_host }

# Spec::Rake::SpecTask.new do |t|
#   t.spec_opts = ['--options', 'spec/spec.opts']
# end
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
  t.pattern = 'spec/**/*_spec.rb'
end

desc 'Generate documentation'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = spec.name
  rdoc.options += spec.rdoc_options
  rdoc.rdoc_files.include(*spec.extra_rdoc_files)
  rdoc.rdoc_files.include("lib")
end

Rake::PackageTask.new(spec, :noversion) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
end

Rake::ExtensionTask.new('rubyaudio_ext', spec) do |ext|
  if RUBY_PLATFORM =~ /mswin|mingw/ then
    # No cross-compile on win, so compile extension to lib/1.[89]
    RUBY_VERSION =~ /(\d+\.\d+)/
    ext.lib_dir = "lib/#{$1}"
  else
    ext.cross_compile = true
    ext.cross_platform = 'arm64-darwin-21'
    ext.cross_config_options << "--with-sndfile-dir=#{$recipes[:libsndfile].path}"
    ext.cross_compiling do |gem_spec|
      gem_spec.post_install_message = "You installed the binary version of this gem!"
    end
  end
end

namespace :cross do
  task :libsndfile do
    recipe = $recipes[:libsndfile]
    checkpoint = "ports/.#{recipe.name}-#{recipe.version}-#{recipe.host}.installed"
    unless File.exist?(checkpoint)
      recipe.cook
      touch checkpoint
    end
    recipe.activate
  end
end
task :cross => ["cross:libsndfile"]

desc "Build gem packages"
task :gems do
  sh "rake cross native gem RUBY_CC_VERSION=1.8.7:1.9.2"
end
