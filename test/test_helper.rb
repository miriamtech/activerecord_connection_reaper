# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'activerecord_connection_reaper'
require 'activerecord_connection_reaper/railtie'

# By default, use an in-memory sqlite3 database specific to this test run.
# Change it by defining the DATABASE_URL environment variable.
ActiveRecord::Base.establish_connection(ENV.fetch('DATABASE_URL', 'sqlite3::memory:'))

class TestCase < Minitest::Test
  def before_setup
    ActiveRecordConnectionReaper::Railtie.initializers.each(&:run)
  end
end

require 'minitest/autorun'
