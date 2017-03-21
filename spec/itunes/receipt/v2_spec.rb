require "spec_helper"

RSpec.describe Itunes::Receipt::V2 do
   let(:password) { '6a9f8013214345a5ad3d3f13462083c1' }

   let(:receipt_data_v2) { IO.read('spec/fixtures/files/kvitok_for_year.base64').strip }

   describe "iTunes valid receipt response" do
      subject do
         service = Itunes::Receipt::Service.new(host: Itunes::Receipt::Service::TEST_HOST,
                                                password: password)

         service.validate(receipt_data: receipt_data_v2).latest_receipt
      end

      it { is_expected.to be_a(Itunes::Receipt::V2) }

      context "#to_h" do
         it { expect(subject.to_h).to be_a(Hash) }
      end

      context "#receipt_type" do
         it { expect(subject.receipt_type).to be_a(String) }
         it { expect(subject.receipt_type).to eq("ProductionSandbox") }
      end

      context "#product_id" do
         it { expect(subject.product_id).to be_a(String) }
         it { expect(subject.product_id).to eq("company_premium_family2_12months") }
      end

      context "#bundle_id" do
         it { expect(subject.bundle_id).to be_a(String) }
         it { expect(subject.bundle_id).to eq("com.company.appclient") }
      end

      context "#version_external_identifier" do
         it { expect(subject.version_external_identifier).to be_a(Integer) }
         it { expect(subject.version_external_identifier).to eq(0) }
      end

      context "#original_application_version" do
         it { expect(subject.original_application_version).to be_a(String) }
         it { expect(subject.original_application_version).to eq("1.0") }
      end

      context "#application_version" do
         it { expect(subject.application_version).to be_a(String) }
         it { expect(subject.application_version).to eq("0") }
      end

      context "#transaction_id" do
         it { expect(subject.transaction_id).to be_a(Integer) }
         it { expect(subject.transaction_id).to eq(1000000283485019) }
      end

      context "#original_transaction_id" do
         it { expect(subject.original_transaction_id).to be_a(Integer) }
         it { expect(subject.original_transaction_id).to eq(1000000279800046) }
      end

      context "#quantity" do
         it { expect(subject.quantity).to be_a(Integer) }
         it { expect(subject.quantity).to eq(1) }
      end

      context "#adam_id" do
         it { expect(subject.adam_id).to be_a(Integer) }
         it { expect(subject.adam_id).to eq(0) }
      end

      context "#app_item_id" do
         it { expect(subject.app_item_id).to be_a(Integer) }
         it { expect(subject.app_item_id).to eq(0) }
      end

      context "#download_id" do
         it { expect(subject.download_id).to be_a(Integer) }
         it { expect(subject.download_id).to eq(0) }
      end

      context "#web_order_line_item_id" do
         it { expect(subject.web_order_line_item_id).to be_a(Integer) }
         it { expect(subject.web_order_line_item_id).to eq(1000000034604139) }
      end

      context "#original_purchase_date" do
         it { expect(subject.original_purchase_date).to be_a(Time) }
         it { expect(subject.original_purchase_date).to eq(Time.at(1488896510)) }
      end

      context "#purchase_date" do
         it { expect(subject.purchase_date).to be_a(Time) }
         it { expect(subject.purchase_date).to eq(Time.at(1490081615)) }
      end

      context "#expires_date" do
         it { expect(subject.expires_date).to be_a(Time) }
         it { expect(subject.expires_date).to eq(Time.at(1490085215)) }
      end

      context "#receipt_creation_date" do
         it { expect(subject.receipt_creation_date).to be_a(Time) }
         it { expect(subject.receipt_creation_date).to eq(Time.at(1490081616)) }
      end

      context "#request_date" do
         it { expect(subject.request_date).to be_a(Time) }
         it { expect(subject.request_date).to eq(Time.at(1490083134.869)) }
      end

      context "#is_trial_period" do
         it { expect(subject.is_trial_period).to be_a(FalseClass) }
         it { expect(subject.is_trial_period).to be_falsey }
      end
   end
end
