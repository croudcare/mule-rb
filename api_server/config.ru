$LOAD_PATH << File.dirname(__FILE__)

require 'broker'
require 'api'

module Configuration
  
  def key
   "key"
  end
  
  def secret
    "secret"
  end

  extend self
end

run ApiServer
