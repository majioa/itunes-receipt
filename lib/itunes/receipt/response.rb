require 'itunes/receipt/version'

class Itunes::Receipt::Response
   attr_reader :data, :response, :request

   def latest_receipt
      info = data['latest_receipt_info'] || data['latest_expired_receipt_info']

      @latest_receipt ||=
      case info
      when Array
         base_receipt = data['receipt'].dup
         base_receipt.delete('in_app')
         receipt = info.sort_by { |x| x['expires_date'] }.last
         Itunes::Receipt::V2.new(data: base_receipt.merge(receipt))
      when Hash
         Itunes::Receipt::V1.new(data: info)
      end
   end

   def receipt
      if receipt = data['receipt']
         @receipt ||=
         if data['receipt']['in_app']
            base_receipt = data['receipt'].dup
            base_receipt.delete('in_app')
            Itunes::Receipt::V2.new(data: base_receipt)
         else
            Itunes::Receipt::V1.new(data: receipt)
         end
      end
   end

   def receipts
      @receipts ||=
      if receipts = data['receipt']['in_app']
         base_receipt = data['receipt'].dup
         base_receipt.delete('in_app')
         receipts.sort_by { |x| x['expires_date'] }.map { |r| Itunes::Receipt::V2.new(data: base_receipt.merge(r)) }
      else
         [ receipt, latest_receipt ]
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
