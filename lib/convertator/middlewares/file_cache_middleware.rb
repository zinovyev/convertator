require 'convertator/middleware'
require 'json'

module Convertator
  module Middlewares
    class FileCacheMiddleware < ::Convertator::Middleware
      DEFAULT_TTL = 3600

      def initialize(file, ttl = DEFAULT_TTL)
        @file = file_open(file)
        @ttl = ttl
      end

      def call
        @file.flock(::File::LOCK_EX)
        if file_zero? || file_old?
          data = @prev.call
          file_write(data.to_json)
        else
          data = JSON.parse(file_read)
        end
        @file.flock(::File::LOCK_UN)
        data
      end

      private

      def file_read
        ::File.read(@file.path)
      end

      def file_zero?
        File.zero? @file.path
      end

      def file_open(file)
        ::File.new(file, 'w+')
      end

      def file_write(data)
        @file.rewind
        @file.write data
      end

      def file_old?
        @ttl < (::Time.new.to_i - @file.mtime.to_i)
      end
    end
  end
end
