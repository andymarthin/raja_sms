module RajaSms
  # Custom error class for rescuing from all Raja Sms API errors
  class Error < StandardError; end

  # Raised when Raja Sms API returns the HTTP status code 400
  class BadRequest < Error; end

  # Raised when Raja Sms API returns the HTTP status code 401
  class Unauthorized < Error; end

  # Raised when Raja Sms API returns the HTTP status code 403
  class Forbidden < Error; end

  # Raised when Raja Sms API returns the HTTP status code 404
  class NotFound < Error; end

  # Raised when Raja Sms API returns the HTTP status code 500
  class InternalServerError < Error; end

  # Raised when Raja Sms API returns the HTTP status code 502
  class BadGateway < Error; end

  # Raised when Raja Sms API returns the HTTP status code 504
  class GatewayTimeout < Error; end

  # Raised when invalid phone number
  class InvalidPhoneNumberError < Error
    def initialize(msg = "Invalid Phone Number Error")
      super
    end
  end

  # Raised when invalid message
  class InvalidMessageError < Error
    def initialize(msg = "Invalid Message Error")
      super
    end
  end

  # Raised when host invalid
  class InvalidHostError < Error
    def initialize(msg = "Invalid Host End Point Error")
      super
    end
  end

  # Raised when api key invalid
  class InvalidApiKeyError < Error
    def initialize(msg= "Invalid Api Key Error")
      super
    end
  end

  # Raised when api return global status not 10
  class ResponseError < Error; end
end