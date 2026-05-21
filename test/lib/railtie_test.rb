# frozen_string_literal: true

require 'test_helper'
require 'activerecord_connection_reaper/railtie'

class RailtieTest < Minitest::Test
  def test_no_error_when_running_initializers
    ActiveRecordConnectionReaper::Railtie.initializers.each(&:run)
  end
end
