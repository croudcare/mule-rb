require 'eventmachine'
require 'em-websocket'

module Mule
  module WebSocketServer
    
    def run
      EM.epoll
      EM.kqueue

      EM.run do
        options = {
          host:    Mule::Config[:websocket_host],
          port:    Mule::Config[:websocket_port],
          debug:   Mule::Config[:debug],
          app_key: Mule::Config[:app_key]
        }

        if Mule::Config[:tls_options]
          options.merge! secure: true,
                         tls_options: Mule::Config[:tls_options]
        end

        EM::WebSocket.start options do |ws|
          ws.class_eval    { attr_accessor :connection_handler }
          ws.onopen do |handshake|
            ws.connection_handler = Mule::Config.socket_handler.new(ws, handshake.path)
          end
          ws.onmessage     { |msg| ws.connection_handler.onmessage msg }
          ws.onclose       { ws.connection_handler.onclose }
        end
      end
    end
    extend self
  end
end
