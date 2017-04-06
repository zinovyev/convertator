module Convertator
  module Middlewares
    class FileCacheMiddleware < Middleware
      DEFAULT_TTL = 3600

      def initialize(file, ttl = DEFAULT_TTL)
        @file = ::File.new(file)
        @ttl = ttl
      end

      def call
        @file.flock(::File::LOCK_EX)
        if @ttl < last_change
          @file.rewind
          @file.write @prev.call
        end
        @file.flock(::File::LOCK_UN)
      end

      private

      def last_change
        Today.new.to_i - @file.mtime.to_i
      end
    end
  end
end
