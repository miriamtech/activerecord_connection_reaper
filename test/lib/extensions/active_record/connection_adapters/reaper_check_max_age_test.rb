# frozen_string_literal: true

require 'test_helper'
require 'activerecord_connection_reaper/extensions/active_record/connection_adapters/abstract_adapter_track_connected_since' # rubocop:disable Layout/LineLength

class ReaperCheckMaxAgeTest < TestCase
  class FakePool
    attr_reader :reaped, :flushed, :retired

    def initialize
      @reaped = false
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
  end

  def test_run_flushes
    refute @pool.flushed
    @reaper.run
    Thread.pass until @pool.flushed
    assert @pool.flushed
  end

  def test_run_retires
    refute @pool.retired
    @reaper.run
    Thread.pass until @pool.retired
    assert @pool.retired
  end
end
