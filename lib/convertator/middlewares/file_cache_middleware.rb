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
          data = @prev.call
          @file.rewind
          @file.write data
        else
          data = @file.read
        end
        @file.flock(::File::LOCK_UN)
        data
      end

      private

      def last_change
        Today.new.to_i - @file.mtime.to_i
      end
    end
  end
end
