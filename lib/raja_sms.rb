require "raja_sms/version"
require "raja_sms/configuration"
require "raja_sms/error"
require "faraday_middleware/raise_http_exception"
require "raja_sms/entities/base"
require "raja_sms/client"

module RajaSms
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
