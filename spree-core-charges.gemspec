version = '0.0.1'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_core_charges'
  s.version     = version
  s.summary     = 'Ability to have basic core charges added to orders'
  s.required_ruby_version = '>= 1.8.7'

  s.files        = Dir['README.markdown', 'lib/*', 'app/**/*', 'config/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true
  
  s.add_dependency('spree_core', '>= 0.30.1')

end
