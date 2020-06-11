Gem::Specification.new do |s|
  s.name        = 'searchkon'
  s.version     = '1.0.3'
  s.date        = '2020-05-24'
  s.summary     = "Advanced activerecord search/filter command"
  s.description = "Advanced activerecord search/filter command"
  s.authors     = ["Majid Imanzade", 'Amin Samadzade']
  s.email       = 'majidimanzade1@gmail.com'
  s.homepage    = 'https://rubygems.org/gems/searchkon'
  s.homepage    = "http://github.com/majidimanzade/searchkon"
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.add_development_dependency("bundler")
  s.add_development_dependency("rake")
  s.add_development_dependency("rspec")
  s.add_development_dependency "sqlite3"

  s.add_dependency "activesupport"
  s.add_dependency "activerecord"
end
