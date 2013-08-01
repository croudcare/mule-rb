require 'fiber'
require 'em-http-request'

module Mule
  module Webhook

    def post(payload)
      return unless Mule::Config.webhook_url

      payload = {
        time_ms: Time.now.strftime('%s%L'), events: [payload]
      }.to_json

      digest   = OpenSSL::Digest::SHA256.new
      hmac     = OpenSSL::HMAC.hexdigest(digest, Mule::Config.secret, payload)

      EM::HttpRequest.new(Mule::Config.webhook_url).
        post(body: payload, head: { "X-Pusher-Key" => Mule::Config.app_key, "X-Pusher-Secret" => hmac })
        # TODO: Exponentially backed off retries for errors
    end

    extend self
  end
end
