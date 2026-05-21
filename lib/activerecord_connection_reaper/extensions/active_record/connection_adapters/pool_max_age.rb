module ActiveRecordConnectionReaper
  module Extensions
    module ActiveRecord
      module ConnectionAdapters
        module PoolMaxAge
          def initialize(*)
            super
            # db_config was added in Rails v6.1
            configuration_hash = if respond_to?(:db_config)
                                   db_config.configuration_hash
                                 else
                                   spec.config
                                 end
            @max_age = configuration_hash[:max_age]&.to_f
          end

          def retire_old_connections(max_age = @max_age)
            max_age ||= Float::INFINITY

            old_connections = synchronize do
              @connections.select { |c| !c.in_use? && c.connection_age&.>=(c.pool_jitter(max_age)) }.each do |conn|
                conn.lease

                @available.delete conn
                @connections.delete conn
              end
            end

            old_connections.each(&:disconnect!)
          end
        end
      end
    end
  end
end
