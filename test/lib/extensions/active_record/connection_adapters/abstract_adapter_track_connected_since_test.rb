# frozen_string_literal: true

require 'test_helper'
require 'activerecord_connection_reaper/extensions/active_record/connection_adapters/abstract_adapter_track_connected_since' # rubocop:disable Layout/LineLength

class AbstractAdapterTrackConnectedSinceTest < TestCase
  def setup
    @connection = ActiveRecord::Base.connection
  end

  def test_connection_age
    assert_operator @connection.connection_age, :>=, 0
    assert_operator @connection.connection_age, :<, 1
  end

  def test_jitter_calculated_on_new_connections
    conns = 4.times.map { ActiveRecord::Base.connection_pool.checkout }

    observed_jitters = conns.map { |conn| conn.instance_variable_get(:@pool_jitter) }

    assert_operator observed_jitters.min, :>=, 0.0
    assert_operator observed_jitters.max, :>, 0.0 # statistically impossible to get all zeros
    assert_operator observed_jitters.max, :<=, 0.5
  end

  def test_jitter_evaluation
    @connection.instance_variable_set(:@pool_jitter, 0.25)
    assert_equal 75, @connection.pool_jitter(100)
  end
end
