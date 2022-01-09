# frozen_string_literal: true

require_relative "lib/local_ip_checker/version"

Gem::Specification.new do |spec|
  spec.name = "local_ip_checker"
  spec.version = LocalIPChecker::VERSION
  spec.summary = "Simple gem to check if provided URL is mapped to local IP address"
  spec.authors = ["Yaroslav Kurbatov"]
  spec.homepage = "https://github.com/yaroslav2k/local_ip_checker"
  spec.email = "yaroslav2kleet@yandex.ru"
  spec.files = Dir.glob("lib/**/*") + %w[README.md CHANGELOG.md LICENSE]
  spec.license = "MIT"

  spec.required_ruby_version = ">= 2.5.0"

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.metadata["rubygems_mfa_required"] = "true"
end
