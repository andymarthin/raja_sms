require "faraday"
require "faraday_middleware"
require "json"

module RajaSms
  class Client

    def initialize(host = nil, api_key = nil)
      @host = host || RajaSms.configuration.host
      @api_key = api_key || RajaSms.configuration.api_key

      raise RajaSms::InvalidHostError if @host.nil?
      raise RajaSms::InvalidApiKeyError if @api_key.nil?

      @connection ||= setup_connection
    end

    def regular(phone_number, message)
      path = '/sms/api_sms_reguler_send_json.php'
      payload = make_payload(phone_number, message)
      response = make_request(path, 'post', payload)
      response_body_handle(response.body)
    end

    def masking(phone_number, message, sending_time = '')
      path = "/sms/api_sms_masking_send_json.php"
      payload = make_payload(phone_number, message)
      payload[:datapacket].first.merge!({sendingdatetime: sending_time})
      response = make_request(path, 'post', payload)
      response_body_handle(response.body)
    end 

    def otp(phone_number, message)
      payload = make_payload(phone_number, message)
      path = "/sms/api_sms_otp_send_json.php"
      response = make_request(path, 'post', payload)
      response_body_handle(response.body)
    end

    def balance
      path = "/sms/api_sms_reguler_balance_json.php"
      payload = {apikey: @api_key}
      response = make_request(path, 'post', payload)
      body = JSON.parse response.body
      attribute = {
        amount: body["balance_respon"].first["Balance"],
        expired: body["balance_respon"].first["Expired"]
      }
      RajaSms::Entities::Balance.new(attribute)
    end

    private

    def make_payload(phone_number, message)
      raise RajaSms::InvalidPhoneNumberError if phone_number.empty?
      raise RajaSms::InvalidMessageError if message.empty?
      {
        apikey: @api_key,
        callbackurl: '',
        datapacket:  [
          {
            number: phone_number,
            message: message
          }
        ]
      }
    end

    def setup_connection
      # start setting up connections
       Faraday.new(url: @host) do |faraday|
         faraday.use FaradayMiddleware::RaiseHttpException
         faraday.response :logger                  # log requests to STDOUT
         faraday.request :url_encoded
         faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
       end
    end

    def make_request(endpoint, method, payload = {}, headers = {})
      # make a request to raja sms
      return @connection.post(endpoint, payload.to_json, headers) if method == 'post'

      @connection.get endpoint
    end

      def response_body_handle(response)
        body = JSON.parse response
        sending_response = body["sending_respon"].first
        status = sending_response["globalstatus"].to_s
        raise RajaSms::ResponseError, sending_response["globalstatustext"] if status != "10"
        sending_response = body["sending_respon"]["datapacket"]
      end
  end
end