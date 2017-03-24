require "spec_helper"

RSpec.describe Itunes::Receipt::V1 do
   let(:password) { '6a9f8013214345a5ad3d3f13462083c1' }

   let(:receipt_data_v1) { Base64.encode64(IO.read('spec/fixtures/files/kvitok_for_year.json')) }
   let(:receipt_data_v1_expired) { Base64.encode64(IO.read('spec/fixtures/files/kvitok_expired.json')) }

   describe "iTunes valid receipt response" do
      subject do
         Timecop.travel(Time.at(1489000000))
         service = Itunes::Receipt::Service.new(host: Itunes::Receipt::Service::TEST_HOST,
                                                password: password)

         service.validate(receipt_data: receipt_data_v1).receipt
      end

      it { is_expected.to be_a(Itunes::Receipt::V1) }
      it { is_expected.to_not be_expired }

      context "#to_h" do
         it { expect(subject.to_h).to be_a(Hash) }
      end

      context "#unique_identifier" do
         it { expect(subject.unique_identifier).to be_a(String) }
         it { expect(subject.unique_identifier).to eq("c793862af88d923d93f66a259f6eafe7d8af9a01") }
      end

      context "#product_id" do
         it { expect(subject.product_id).to be_a(String) }
         it { expect(subject.product_id).to eq("company_premium_family2_12months") }
      end

      context "#bid" do
         it { expect(subject.bid).to be_a(String) }
         it { expect(subject.bid).to eq("com.company.appclient") }
      end

      context "#unique_vendor_identifier" do
         it { expect(subject.unique_vendor_identifier).to be_a(String) }
         it { expect(subject.unique_vendor_identifier).to eq("BB21C9EC-734F-4762-9998-42C06A4271CC") }
      end

      context "#bvrs" do
         it { expect(subject.bvrs).to be_a(String) }
         it { expect(subject.bvrs).to eq("2.5.0.3") }
      end

      context "#transaction_id" do
         it { expect(subject.transaction_id).to be_a(Integer) }
         it { expect(subject.transaction_id).to eq(1000000280472909) }
      end

      context "#original_transaction_id" do
         it { expect(subject.original_transaction_id).to be_a(Integer) }
         it { expect(subject.original_transaction_id).to eq(1000000279800046) }
      end

      context "#quantity" do
         it { expect(subject.quantity).to be_a(Integer) }
         it { expect(subject.quantity).to eq(1) }
      end

      context "#item_id" do
         it { expect(subject.item_id).to be_a(Integer) }
         it { expect(subject.item_id).to eq(1064424591) }
      end

      context "#web_order_line_item_id" do
         it { expect(subject.web_order_line_item_id).to be_a(Integer) }
         it { expect(subject.web_order_line_item_id).to eq(1000000034519685) }
      end

      context "#original_purchase_date" do
         it { expect(subject.original_purchase_date).to be_a(Time) }
         it { expect(subject.original_purchase_date).to eq(Time.parse("2017-03-07 17:21:50")) }
      end

      context "#purchase_date" do
         it { expect(subject.purchase_date).to be_a(Time) }
         it { expect(subject.purchase_date).to eq(Time.at(1489052188.351)) }
      end

      context "#expires_date" do
         it { expect(subject.expires_date).to be_a(Time) }
         it { expect(subject.expires_date).to eq(Time.at(1489055788.351)) }
      end
   end

   describe "iTunes valid expired response" do
      subject do
         service = Itunes::Receipt::Service.new(host: Itunes::Receipt::Service::TEST_HOST,
                                                password: password)

         service.validate(receipt_data: receipt_data_v1_expired).receipt
      end

      it { is_expected.to be_a(Itunes::Receipt::V1) }
      it { is_expected.to be_expired }

      context "#to_h" do
         it { expect(subject.to_h).to be_a(Hash) }
      end

      context "#unique_identifier" do
         it { expect(subject.unique_identifier).to be_a(String) }
         it { expect(subject.unique_identifier).to eq("c793862af88d923d93f66a259f6eafe7d8af9a01") }
      end

      context "#product_id" do
         it { expect(subject.product_id).to be_a(String) }
         it { expect(subject.product_id).to eq("company_premium_family2_1month") }
      end

      context "#bid" do
         it { expect(subject.bid).to be_a(String) }
         it { expect(subject.bid).to eq("com.company.appclient") }
      end

      context "#unique_vendor_identifier" do
         it { expect(subject.unique_vendor_identifier).to be_a(String) }
         it { expect(subject.unique_vendor_identifier).to eq("D9D54C42-F360-488B-9AB9-700064C69037") }
      end

      context "#bvrs" do
         it { expect(subject.bvrs).to be_a(String) }
         it { expect(subject.bvrs).to eq("2.5.0.3") }
      end

      context "#transaction_id" do
         it { expect(subject.transaction_id).to be_a(Integer) }
         it { expect(subject.transaction_id).to eq(1000000279802573) }
      end

      context "#original_transaction_id" do
         it { expect(subject.original_transaction_id).to be_a(Integer) }
         it { expect(subject.original_transaction_id).to eq(1000000279800046) }
      end

      context "#quantity" do
         it { expect(subject.quantity).to be_a(Integer) }
         it { expect(subject.quantity).to eq(1) }
      end

      context "#item_id" do
         it { expect(subject.item_id).to be_a(Integer) }
         it { expect(subject.item_id).to eq(1064424591) }
      end

      context "#web_order_line_item_id" do
         it { expect(subject.web_order_line_item_id).to be_a(Integer) }
         it { expect(subject.web_order_line_item_id).to eq(1000000034519453) }
      end

      context "#original_purchase_date" do
         it { expect(subject.original_purchase_date).to be_a(Time) }
         it { expect(subject.original_purchase_date).to eq(Time.at(1488896510)) }
      end

      context "#purchase_date" do
         it { expect(subject.purchase_date).to be_a(Time) }
         it { expect(subject.purchase_date).to eq(Time.at(1488896840)) }
      end

      context "#expires_date" do
         it { expect(subject.expires_date).to be_a(Time) }
         it { expect(subject.expires_date).to eq(Time.at(1488897140)) }
      end
   end
end
