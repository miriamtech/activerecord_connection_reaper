require 'weakref'

module ActiveRecordConnectionReaper
  module Extensions
    module ActiveRecord
      module ConnectionAdapters
        module ReaperCheckMaxAge
          def self.prepended(base)
            base.instance_variable_set(:@mutex, Mutex.new) if base.instance_variable_get(:@mutex).nil?
            base.instance_variable_set(:@pools, {}) if base.instance_variable_get(:@pools).nil?
            base.instance_variable_set(:@threads, {}) if base.instance_variable_get(:@threads).nil?

            base.singleton_class.send(:prepend, ClassMethods)
          end

          module ClassMethods
            def __patched_register_pool(pool, frequency) # :nodoc:
              @mutex.synchronize do
                @threads[frequency] = __patched_spawn_thread(frequency) unless @threads[frequency]&.alive?
                @pools[frequency] ||= []
                @pools[frequency] << WeakRef.new(pool)
              end
            end

            private

            def __patched_spawn_thread(frequency) # rubocop:disable Metrics/MethodLength
              Thread.new(frequency) do |t|
                # Advise multi-threaded app servers to ignore this thread for
                # the purposes of fork safety warnings
                Thread.current.thread_variable_set(:fork_safe, true)
                Thread.current.name = 'AR Pool Reaper'
                running = true
                while running
                  sleep t
                  @mutex.synchronize do
                    @pools[frequency].select! do |pool|
                      pool.weakref_alive? && !pool.__patched_discarded?
                    end

                    @pools[frequency].each do |p|
                      p.reap
                      p.flush
                      p.retire_old_connections
                    rescue WeakRef::RefError
                      # Pool has been garbage collected. Nothing we can do here, move on.
                    end

                    if @pools[frequency].empty?
                      @pools.delete(frequency)
                      @threads.delete(frequency)
                      running = false
                    end
                  end
                end
              end
            end
          end

          def run
            return unless frequency&.positive?
            self.class.__patched_register_pool(pool, frequency)
          end
        end
      end
    end
  end
end
