# frozen_string_literal: true

source 'https://rubygems.org'
ruby_version = Gem::Version.new(RUBY_VERSION)

# Specify your gem's dependencies in activerecord_connection_reaper.gemspec
gemspec

gem 'appraisal', '~> 2.5'
gem 'rake', '~> 13.0'

gem 'minitest', '~> 5.15'

# Lock these three down to specific versions so they don't change in Appraisals.
# Feel free to update, just make sure linting passes.
gem 'rubocop', '1.28.2'
gem 'rubocop-minitest', '0.19.1'
gem 'rubocop-rails', '2.14.2'

gem 'sqlite3', '>= 1.0', '< 3'

gem 'concurrent-ruby', '<= 1.3.4' if ruby_version < Gem::Version.new('2.7.0')
