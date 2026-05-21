module ActiveRecordConnectionReaper
  module Extensions
    module ActiveRecord
      module ConnectionAdapters
        module ReaperCheckMaxAge
          def run
            return unless frequency&.positive?
            Thread.new(frequency, pool) do |t, p|
              loop do
                sleep t
                run_once(p)
              end
            end
          end

          private

          def run_once(pool)
            pool.reap
            pool.flush
            pool.retire_old_connections
          end
        end
      end
    end
  end
end
