require "itunes/receipt/version"

module Itunes::Receipt
   class Error < StandardError
      attr_reader :status

      def initialize code
         @status = code
      end

      def self.new code
         return super if self != Itunes::Receipt::Error

         type = Itunes::Receipt::ERRORS[code]
         type.is_a?(NilClass) && super || type.new(code)
      end
   end

   class InvalidJsonError < Error
      def message
         'The App Store could not read the JSON object you provided (21000)'
      end
   end

   class InvalidReceiptFormatError < Error
      def message
         'The App Store could not read the JSON object you provided (21002)'
      end
   end

   class ReceiptAuthenticationError < Error
      def message
         'The receipt could not be authenticated (21003)'
      end
   end

   class InvalidSharedSecretError < Error
      def message
         'The shared secret you provided does not match the shared secret on file for your account (21004)'
      end
   end

   class ReceiptServerUnavailableError < Error
      def message
         'The receipt server is not currently available (21005)'
      end
   end

   class SubscriptionExpiredError < Error
      def message
         'This receipt is valid but the subscription has expired (21006)'
      end
   end

   class TestEnvironmentRequiredError < Error
      def message
         <<-'end;'
           This receipt is from the test environment, but it was sent to the production environment
           for verification. Send it to the test environment instead (21007)
         end;
      end
   end

   class ProductionEnvironmentRequiredError < Error
      def message
         <<-'end;'
           This receipt is from the production environment, but it was sent to the test environment
           for verification. Send it to the production environment instead (21008)
         end;
      end
   end

   ERRORS = {
     21000 => InvalidJsonError,
     21002 => InvalidReceiptFormatError,
     21003 => ReceiptAuthenticationError,
     21004 => InvalidSharedSecretError,
     21005 => ReceiptServerUnavailableError,
     21006 => SubscriptionExpiredError,
     21007 => TestEnvironmentRequiredError,
     21008 => ProductionEnvironmentRequiredError,
   }
end
