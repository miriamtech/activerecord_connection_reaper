# frozen_string_literal: true

require 'rails'

module ActiveRecordConnectionReaper
  class Railtie < Rails::Railtie
    initializer 'activerecord_connection_reaper.apply_patches' do
      require 'activerecord_connection_reaper/extensions/active_record/connection_adapters/abstract_adapter_track_connected_since' # rubocop:disable Layout/LineLength
      require 'activerecord_connection_reaper/extensions/active_record/connection_adapters/reaper_check_max_age'
      require 'activerecord_connection_reaper/extensions/active_record/connection_adapters/pool_max_age'

      ActiveRecord::ConnectionAdapters::AbstractAdapter.prepend(ActiveRecordConnectionReaper::Extensions::ActiveRecord::ConnectionAdapters::AbstractAdapterTrackConnectedSince)
      ActiveRecord::ConnectionAdapters::ConnectionPool::Reaper.prepend(ActiveRecordConnectionReaper::Extensions::ActiveRecord::ConnectionAdapters::ReaperCheckMaxAge)
      ActiveRecord::ConnectionAdapters::ConnectionPool.prepend(ActiveRecordConnectionReaper::Extensions::ActiveRecord::ConnectionAdapters::PoolMaxAge)
    end
  end
end
