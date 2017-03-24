require "itunes/receipt/version"
require "itunes/receipt/properties"

class Itunes::Receipt::V1
   PROPERTY_LIST = %w(unique_identifier product_id bid unique_vendor_identifier bvrs transaction_id original_transaction_id
                      quantity item_id web_order_line_item_id original_purchase_date purchase_date expires_date)

   include Itunes::Receipt::Properties

   def to_h
      data.dup
   end

   def expired?
      self.expires_date < Time.now
   end

   protected

   def initialize data: nil
      @data = data
   end
end
