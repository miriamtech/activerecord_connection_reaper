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

def pool_with_options(**options)
  pool = ActiveRecord::Base.connection_pool
  config = nil
  if pool.respond_to? :pool_config # This was introduced in Rails v6.1
    pool_config = ActiveRecord::Base.connection_pool.pool_config
    db_config = pool_config.db_config
    new_db_config = ActiveRecord::DatabaseConfigurations::HashConfig.new(db_config.env_name,
                                                                         db_config.name,
                                                                         db_config.configuration_hash.merge(options))

    args = [ActiveRecord::Base, new_db_config]
    if pool_config.respond_to? :role # This was introduced in Rails v7.0
      args << pool_config.role
      args << pool_config.shard
    end
    config = ActiveRecord::ConnectionAdapters::PoolConfig.new(*args)
  else
    config = ActiveRecord::Base.connection_pool.spec.dup
    config.config.merge!(options)
  end
  ActiveRecord::ConnectionAdapters::ConnectionPool.new(config)
end

require 'minitest/autorun'
