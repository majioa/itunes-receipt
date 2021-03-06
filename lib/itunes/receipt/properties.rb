require "itunes/receipt/version"

module Itunes::Receipt::Properties
   LIST = {
      'unique_identifier' => true,
      'product_id' => true,
      'bid' => true,
      'unique_vendor_identifier' => true,
      'bvrs' => true,
      'transaction_id' => proc { |v| v.to_i },
      'original_transaction_id' => proc { |v| v.to_i },
      'quantity' => proc { |v| v.to_i },
      'item_id' => proc { |v| v.to_i },
      'web_order_line_item_id' => proc { |v| v.to_i },
      'original_purchase_date' => {
         name: 'original_purchase_date_ms',
         prc: proc { |v| Time.at(v.to_f / 1_000) },
      },
      'purchase_date' => {
         name: 'purchase_date_ms',
         prc: proc { |v| Time.at(v.to_f / 1_000) },
      },
      'expires_date' => {
         name: [ 'expires_date_ms', 'expires_date' ],
         prc: proc { |v| Time.at(v.to_f / 1_000) },
      },
      'receipt_type' => true,
      'adam_id' => proc { |v| v.to_i },
      'app_item_id' => proc { |v| v.to_i },
      'bundle_id' => true,
      'application_version' => true,
      'download_id' => proc { |v| v.to_i },
      'version_external_identifier' => proc { |v| v.to_i },
      'receipt_creation_date' => {
         name: 'receipt_creation_date_ms',
         prc: proc { |v| Time.at(v.to_f / 1_000) },
      },
      'request_date' => {
         name: 'request_date_ms',
         prc: proc { |v| Time.at(v.to_f / 1_000) },
      },
      'original_application_version' => true,
      'is_trial_period' => proc { |v| v == 'true' },
   }

   def self.included klass
      klass.class_eval do
         attr_reader :data
      end

      (LIST.keys & klass::PROPERTY_LIST).each do |prop|
         case value = LIST[prop]
         when TrueClass
            klass.class_eval <<-"end;", __FILE__, __LINE__+1
               def #{prop}
                  data['#{prop}']
               end
            end;
         when Hash
            case value[:name]
            when String
               klass.class_eval <<-"end;", __FILE__, __LINE__+1
                  def #{prop}
                     Itunes::Receipt::Properties::LIST['#{prop}'][:prc][data['#{value[:name]}']]
                  end
               end;
            when Array
               klass.class_eval <<-"end;", __FILE__, __LINE__+1
                  def #{prop}
                     #{value[:name]}.reduce(nil) do |res, name|
                        if not res and data[name]
                           Itunes::Receipt::Properties::LIST['#{prop}'][:prc][data[name]]
                        else
                           res
                        end
                     end
                  end
               end;
            end
         when Proc
            klass.class_eval <<-"end;", __FILE__, __LINE__+1
               def #{prop}
                  Itunes::Receipt::Properties::LIST['#{prop}'][data['#{prop}']]
               end
            end;
         end
      end
   end
end
