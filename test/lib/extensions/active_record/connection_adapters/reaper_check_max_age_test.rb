# frozen_string_literal: true

require 'test_helper'
require 'activerecord_connection_reaper/extensions/active_record/connection_adapters/abstract_adapter_track_connected_since' # rubocop:disable Layout/LineLength

class ReaperCheckMaxAgeTest < Minitest::Test
  class FakePool
    attr_reader :reaped, :flushed, :retired

    def initialize(discarded: false)
      @reaped = false
      @flushed = false
      @retired = false
      @discarded = discarded
    end

    def reap
      @reaped = true
    end

    def flush
      @flushed = true
    end

    def retire_old_connections
      @retired = true
    end

    def discard!
      @discarded = true
    end

    def __patched_discarded?
      @discarded
    end
  end

  def setup
    @pool = FakePool.new
    @reaper = ActiveRecord::ConnectionAdapters::ConnectionPool::Reaper.new(@pool, 0.0001)
  end

  def test_run_reaps
    refute @pool.reaped
    @reaper.run
    Thread.pass until @pool.reaped
    assert @pool.reaped
  ensure
    @pool.discard!
  end

  def test_run_flushes
    refute @pool.flushed
    @reaper.run
    Thread.pass until @pool.flushed
    assert @pool.flushed
  ensure
    @pool.discard!
  end

  def test_run_retires
    refute @pool.retired
    @reaper.run
    Thread.pass until @pool.retired
    assert @pool.retired
  ensure
    @pool.discard!
  end

  def test_reaper_does_not_reap_discarded_connection_pools
    discarded_pool = FakePool.new(discarded: true)
    pool = FakePool.new
    frequency = 0.001

    ActiveRecord::ConnectionAdapters::ConnectionPool::Reaper.new(discarded_pool, frequency).run
    ActiveRecord::ConnectionAdapters::ConnectionPool::Reaper.new(pool, frequency).run

    Thread.pass until pool.flushed

    refute discarded_pool.reaped
    assert pool.reaped
  ensure
    pool.discard!
  end
end
