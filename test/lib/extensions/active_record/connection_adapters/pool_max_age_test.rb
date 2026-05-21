# frozen_string_literal: true

require 'test_helper'
require 'activerecord_connection_reaper/extensions/active_record/connection_adapters/abstract_adapter_track_connected_since' # rubocop:disable Layout/LineLength

class PoolMaxAgeTest < TestCase
  def test_max_age
    pool = pool_with_options(max_age: 10)
    conn = pool.checkout

    # In older versions of Rails, the connection we checked out was already
    # connected and active. As of v7.2, it needs to be connected first.
    if Rails.gem_version >= Gem::Version.new('7.2.0')
      refute_predicate conn, :active?
      conn.connect!
    end

    assert_predicate conn, :active?
    assert_operator conn.connection_age, :>=, 0
    assert_operator conn.connection_age, :<, 1

    conn.instance_variable_set(:@connected_since, Process.clock_gettime(Process::CLOCK_MONOTONIC) - 11)

    assert_operator conn.connection_age, :>, 10

    pool.checkin conn
    pool.retire_old_connections

    refute_predicate conn, :active?
  end

  def test_max_age_with_jitter
    pool = pool_with_options(max_age: 20, pool_jitter: 0)
    conn = pool.checkout
    conn.instance_variable_set(:@pool_jitter, 0.5)

    # In older versions of Rails, the connection we checked out was already
    # connected and active. As of v7.2, it needs to be connected first.
    if Rails.gem_version >= Gem::Version.new('7.2.0')
      refute_predicate conn, :active?
      conn.connect!
    end

    assert_predicate conn, :active?
    assert_operator conn.connection_age, :>=, 0
    assert_operator conn.connection_age, :<, 1

    conn.instance_variable_set(:@connected_since, Process.clock_gettime(Process::CLOCK_MONOTONIC) - 11)

    assert_operator conn.connection_age, :>, 10

    pool.checkin conn
    pool.retire_old_connections

    refute_predicate conn, :active?
  end

  private

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
end
