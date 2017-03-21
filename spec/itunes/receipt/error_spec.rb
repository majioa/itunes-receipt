require "spec_helper"

RSpec.describe Itunes::Receipt::Error do
   context "error list check" do
      err_codes = [21000, 21002, 21003, 21004, 21005, 21006, 21007, 21008]
      classes = %w(
         InvalidJsonError
         InvalidReceiptFormatError
         ReceiptAuthenticationError
         InvalidSharedSecretError
         ReceiptServerUnavailableError
         SubscriptionExpiredError
         TestEnvironmentRequiredError
         ProductionEnvironmentRequiredError)

      err_codes.each.with_index do |code, i|
         receipt = described_class.new(code)

         it { expect(receipt).to be_a(Itunes::Receipt.const_get(classes[i])) }
      end
   end
end
