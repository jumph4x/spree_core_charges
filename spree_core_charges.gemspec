version = '1.0.0'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_core_charges'
  s.version     = version
  s.authors     = ['Denis Ivanov']
  s.summary     = 'Ability to have basic core charges added to orders'
  s.required_ruby_version = '>= 1.8.7'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency('spree_core', '~> 1.1.3')

  s.add_development_dependency 'capybara', '1.0.1'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.7'
  s.add_development_dependency 'sqlite3'
end
