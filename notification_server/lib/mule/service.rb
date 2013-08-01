module Mule
  module Service
    def run
      Mule::Config[:require].each { |f| require f }
      Mule::WebSocketServer.run
    end

    def stop
      EM.stop if EM.reactor_running?
    end

    extend self
    Signal.trap('HUP') { Mule::Service.stop }
  end
end
