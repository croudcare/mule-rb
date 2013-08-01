# encoding: utf-8
require 'bundler/setup'
Bundler.require :default

require 'active_support/core_ext/hash'
require 'json'

class ApiServer < Sinatra::Base
  set :raise_errors, lambda { false }
  set :show_exceptions, false

  error do 
    halt 500, "500 Internal Error"
  end

  error(Signature::AuthenticationError) { |c| halt 401, "401 UNAUTHORIZED\n" }

  before '/apps/*' do
    Signature::Request.new('POST', env['PATH_INFO'], params.except('channel_id', 'app_id', 'splat', 'captures')).
         authenticate { |key| Signature::Token.new key, Configuration.secret }
  end

  before '/apps/*' do
    post_body = request.body.read
    post_body.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    @body = JSON.parse(post_body)
  end
  
  post '/apps/:app_id/events' do
    @body["channels"].each do |channel|
      publish(channel, @body['name'], @body['data']) 
    end
    status 202
  end

  post '/apps/:app_id/channels/:channel_id/events' do
    publish(params[:channel_id], params['name'],  @body) 
    status 202
  end

  def payload(channel, event, data)
    {
      event:     event,
      data:      data,
      channel:   channel,
      socket_id: params[:socket_id]
    }.select { |_,v| v }.to_json
  end

  def publish(channel, event, data)
    Mule::Broker.publish(channel, payload(channel, event, data))
  end

end

