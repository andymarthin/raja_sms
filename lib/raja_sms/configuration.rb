module RajaSms
  class Configuration
    attr_accessor :host, :api_key

    def initialize
      @host = nil
      @api_key = nil 
    end
  end
end