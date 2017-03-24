require "itunes/receipt/version"
require "itunes/receipt/properties"

class Itunes::Receipt::V2
   PROPERTY_LIST = %w(receipt_type adam_id app_item_id bundle_id application_version download_id version_external_identifier
                      product_id receipt_creation_date request_date original_purchase_date original_application_version
                      transaction_id original_transaction_id quantity purchase_date expires_date web_order_line_item_id
                      is_trial_period)

   include Itunes::Receipt::Properties

   def to_h
      YAML.load(data.to_yaml)
   end

   def expired?
      self.expires_date < Time.now
   end

   protected

   def initialize data: nil
      @data = data
   end
end
