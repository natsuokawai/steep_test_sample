# -*- encoding: utf-8 -*-
# stub: rbs_rails 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rbs_rails".freeze
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "https://github.com/pocke/rbs_rails", "source_code_uri" => "https://github.com/pocke/rbs_rails" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Masataka Pocke Kuwabara".freeze]
  s.bindir = "exe".freeze
  s.date = "2020-02-20"
  s.description = "A RBS files generator for Rails application".freeze
  s.email = ["kuwabara@pocke.me".freeze]
  s.homepage = "https://github.com/pocke/rbs_rails".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "A RBS files generator for Rails application".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<parser>.freeze, [">= 0"])
  else
    s.add_dependency(%q<parser>.freeze, [">= 0"])
  end
end
