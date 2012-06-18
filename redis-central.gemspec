require 'lib/redis/central/version'

Gem::Specification.new do |s|
  s.name     = 'redis-central'
  s.version  = Redis::Central::VERSION
  s.date     = Time.now.strftime('%Y-%m-%d')
  s.summary  = "Provides easy access, and global namespacing, to a single redis client"
  s.homepage = 'http://github.com/siwilkins/redis-central'
  s.has_rdoc = false
  s.email    = 'si.wilkins@gmail.com'
  s.author   = 'Si Wilkins'
  s.has_rdoc = false

  s.files = %w{README.md Rakefile LICENCE} + Dir["lib/**/*.rb"] + Dir["spec/**/*.rb"]

  s.add_dependency 'redis-namespace'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'mocha'

  s.description = <<EOS
Provides easy access and configuration to a single per-application/thread, 
optionally namespaced, redis client.
EOS

end
