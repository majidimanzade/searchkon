Gem::Specification.new do |s|
  s.name        = 'elliot'
  s.version     = '0.0.11'
  s.date        = '2020-05-24'
  s.summary     = "Search Command"
  s.description = "make search easy"
  s.authors     = ["Majid Imanzade"]
  s.email       = 'majidimanzade1@gmail.com'
  s.homepage    = 'https://rubygems.org/gems/elliot'
  s.homepage    = "http://github.com/majidimanzade/elliot"
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.add_development_dependency("bundler")
  s.add_development_dependency("rake")
  s.add_development_dependency("rspec")
end
