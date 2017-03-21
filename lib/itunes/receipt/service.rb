require 'itunes/receipt/version'
require 'itunes/receipt/v1'
require 'excon'

class Itunes::Receipt::Service
   TEST_HOST = 'sandbox.itunes.apple.com'
   PRODUCTION_HOST = 'buy.itunes.apple.com'

   attr_reader :host, :password, :connection

   def initialize host: PRODUCTION_HOST, password: nil
      @host = host
      @password = password
      @connection = Excon.new("https://#{host}")
   end

   def validate receipt_data: nil
      request = {
         'receipt-data' => receipt_data,
         'password' => password
      }

      response = connection.post(path: '/verifyReceipt', body: request.to_json)

      Itunes::Receipt::Response.new(response: response, request: request)
   end
end
