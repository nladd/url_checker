Gem::Specification.new do |s|
  s.name        = 'url_checker'
  s.version     = '0.1.3'
  s.date        = '2019-09-23'
  s.summary     = "Verify if given URLs will return a success HTTP status code"
  s.description = "Provided a list of URLs, they will be checked to determine if each URL returns a success HTTP status code (2XX or 3XX) or an unsuccessful status code (4XX or 5XX)"
  s.authors     = ["Nathan Ladd"]
  s.email       = 'Nathan.Ladd@monster.com'

  s.files         = `find . -name "*.rb"`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency('resque', '~> 2.0.0')
end
