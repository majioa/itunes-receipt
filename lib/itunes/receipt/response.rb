require 'itunes/receipt/version'

class Itunes::Receipt::Response
   attr_reader :data, :response, :request

   def latest_receipt
      if receipt = data['latest_receipt_info']
         @latest_receipt ||= Itunes::Receipt::V1.new(data: receipt)
      end
   end

   def receipt
      if receipt = data['receipt']
         @receipt ||= Itunes::Receipt::V1.new(data: receipt)
      end
   end

   def status
      @status ||= data['status']
   end

   def valid?
      status == 0
   end

   def validate!
      if not valid?
         raise(Itunes::Receipt::Error.new(status))
      end

      true
   end

   protected

   def initialize response: nil, request: nil
      @response = response
      @request = request
      @data = JSON.parse(response.body)
   end
end
