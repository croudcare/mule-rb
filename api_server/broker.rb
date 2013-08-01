module Mule 
  module Broker
    extend Forwardable

      def_delegator  :publisher, :publish
      def_delegators :subscriber, :subscribe
      def_delegators :regular_connection, :hgetall, :hdel, :hset, :hincrby

      private

      def regular_connection
        @regular_connection ||= new_connection
      end

      def publisher
        @publisher ||= new_connection
      end

      def new_connection
        ::Redis.new
      end

      extend self
    end
end
