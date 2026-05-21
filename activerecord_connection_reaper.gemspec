# frozen_string_literal: true

require_relative 'lib/activerecord_connection_reaper/version'

Gem::Specification.new do |spec|
  spec.name = 'activerecord_connection_reaper'
  spec.version = ActiveRecordConnectionReaper::VERSION
  spec.authors = ['Miriam Technologies']
  spec.email = ['developers@miriamtech.com']

  spec.summary = 'Retire old ActiveRecord database connections'
  spec.description = "This is mostly a backport of Rails v8.1's max_age database parameter."

  spec.license = 'MIT'
  spec.homepage = 'https://github.com/miriamtech/activerecord_connection_reaper'
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.required_ruby_version = '~> 3.4.0'

  # Uncomment the line below to require MFA for gem pushes.
  # This helps protect your gem from supply chain attacks by ensuring
  # no one can publish a new version without multi-factor authentication.
  # See: https://guides.rubygems.org/mfa-requirement-opt-in/
  # spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir['{lib}/**/*', 'LICENSE.txt', 'Rakefile', 'README.md']
  spec.require_paths = ['lib']

  # Version 8.1 was where native support for max_age etc. landed, so this gem
  # is no longer necessary at that point.
  spec.add_dependency 'activerecord', '>= 5.1', '< 8.1'
  spec.add_dependency 'railties', '>= 5.1', '< 8.1'
end
