lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dashamail/version"
Gem::Specification.new do |s|
  s.name        = 'dashamail'
  s.version     = Dashamail::VERSION
  s.date        = '2022-05-05'
  s.summary     = "DashaMail"
  s.description = ""
  s.authors     = ["Pavel Osetrov"]
  s.email       = 'pavel.osetrov@me.com'
  s.files = Dir['lib/**/*', 'LICENSE', 'README.markdown']

  s.homepage    = 'https://github.com/osetrov/dashamail'
  s.license       = 'MIT'

  s.add_dependency('faraday', '>= 0.16.0')
  s.add_dependency('multi_json', '>= 1.11.0')

  s.require_paths = ["lib"]
  s.required_ruby_version = '>= 2.3.8'
end

