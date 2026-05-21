module ActiveRecordConnectionReaper
  module Extensions
    module ActiveRecord
      module ConnectionAdapters
        module AbstractAdapterTrackConnectedSince
          def initialize(*args, **kwargs, &block)
            super
            @connected_since = Process.clock_gettime(Process::CLOCK_MONOTONIC)
            @pool_jitter = rand * max_jitter
          end

          def reconnect!(*args, **kwargs, &block)
            super
            @connected_since = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          end

          def connection_age
            return unless raw_connection && @connected_since
            Process.clock_gettime(Process::CLOCK_MONOTONIC) - @connected_since
          end

          def pool_jitter(duration)
            duration * (1.0 - @pool_jitter)
          end

          MAX_JITTER = 1.0
          def max_jitter
            (@config[:pool_jitter] || 0.2).to_f.clamp(0.0, MAX_JITTER)
          end
        end
      end
    end
  end
end
