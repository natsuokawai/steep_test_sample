# -*- encoding: utf-8 -*-
# stub: steep 0.13.0 ruby lib

Gem::Specification.new do |s|
  s.name = "steep".freeze
  s.version = "0.13.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Soutaro Matsumoto".freeze]
  s.bindir = "exe".freeze
  s.date = "2020-02-16"
  s.description = "Gradual Typing for Ruby".freeze
  s.email = ["matsumoto@soutaro.com".freeze]
  s.executables = ["rbs".freeze, "ruby-signature".freeze, "steep".freeze]
  s.files = ["exe/rbs".freeze, "exe/ruby-signature".freeze, "exe/steep".freeze]
  s.homepage = "https://github.com/soutaro/steep".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6.0".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Gradual Typing for Ruby".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, [">= 1.13"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_development_dependency(%q<racc>.freeze, ["~> 1.4"])
    s.add_development_dependency(%q<minitest-reporters>.freeze, ["~> 1.3.6"])
    s.add_development_dependency(%q<minitest-hooks>.freeze, ["~> 1.5.0"])
    s.add_runtime_dependency(%q<parser>.freeze, ["~> 2.7.0"])
    s.add_runtime_dependency(%q<ast_utils>.freeze, ["~> 0.3.0"])
    s.add_runtime_dependency(%q<activesupport>.freeze, [">= 5.1"])
    s.add_runtime_dependency(%q<rainbow>.freeze, [">= 2.2.2", "< 4.0"])
    s.add_runtime_dependency(%q<listen>.freeze, ["~> 3.1"])
    s.add_runtime_dependency(%q<pry>.freeze, ["~> 0.12.2"])
    s.add_runtime_dependency(%q<language_server-protocol>.freeze, ["~> 3.14.0.1"])
  else
    s.add_dependency(%q<bundler>.freeze, [">= 1.13"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_dependency(%q<racc>.freeze, ["~> 1.4"])
    s.add_dependency(%q<minitest-reporters>.freeze, ["~> 1.3.6"])
    s.add_dependency(%q<minitest-hooks>.freeze, ["~> 1.5.0"])
    s.add_dependency(%q<parser>.freeze, ["~> 2.7.0"])
    s.add_dependency(%q<ast_utils>.freeze, ["~> 0.3.0"])
    s.add_dependency(%q<activesupport>.freeze, [">= 5.1"])
    s.add_dependency(%q<rainbow>.freeze, [">= 2.2.2", "< 4.0"])
    s.add_dependency(%q<listen>.freeze, ["~> 3.1"])
    s.add_dependency(%q<pry>.freeze, ["~> 0.12.2"])
    s.add_dependency(%q<language_server-protocol>.freeze, ["~> 3.14.0.1"])
  end
end
