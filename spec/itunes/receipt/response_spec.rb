require "spec_helper"

RSpec.describe Itunes::Receipt::Response do
   let(:password) { '6a9f8013214345a5ad3d3f13462083c1' }
   let(:invalid_password) { 'invalid_password' }

   let(:receipt_data_v1) { Base64.encode64(IO.read('spec/fixtures/files/kvitok_for_year.json')) }
   let(:receipt_data_v1_invalid_data) { 'invalid receipt data' }

   let(:receipt_data_v2) { IO.read('spec/fixtures/files/kvitok_for_year.base64').strip }

   describe "iTunes valid receipt v1 response" do
      subject do
         service = Itunes::Receipt::Service.new(host: Itunes::Receipt::Service::TEST_HOST,
                                                password: password)

         service.validate(receipt_data: receipt_data_v1)
      end

      it { is_expected.to be_a(Itunes::Receipt::Response) }
      it { expect(subject).to be_valid }

      context "#request" do
         it { expect(subject.request).to be_a(Hash) }
      end

      context "#response" do
         it { expect(subject.response).to be_a(Excon::Response) }
      end

      context "#receipt" do
         it { expect(subject.latest_receipt).to be_a(Itunes::Receipt::V1) }
      end

      context "#latest_receipt" do
         it { expect(subject.latest_receipt).to be_a(Itunes::Receipt::V1) }
      end

      context "#data" do
         it { expect(subject.data).to be_a(Hash) }
      end

      context "#status" do
         it { expect(subject.status).to be_an(Integer) }
         it { expect(subject.status).to eq(0) }
      end

      context "#validate!" do
         it { expect(subject.validate!).to be_truthy }
      end
   end

   describe "iTunes invalid receipt data" do
      subject do
         service = Itunes::Receipt::Service.new(host: Itunes::Receipt::Service::TEST_HOST,
                                                password: password)

         service.validate(receipt_data: receipt_data_v1_invalid_data)
      end

      it { is_expected.to be_a(Itunes::Receipt::Response) }
      it { expect(subject).to_not be_valid }

      context "#request" do
         it { expect(subject.request).to be_a(Hash) }
      end

      context "#response" do
         it { expect(subject.response).to be_a(Excon::Response) }
      end

      context "#receipt" do
         it { expect(subject.latest_receipt).to be_nil }
      end

      context "#latest_receipt" do
         it { expect(subject.latest_receipt).to be_nil }
      end

      context "#data" do
         it { expect(subject.data).to be_a(Hash) }
      end

      context "#status" do
         it { expect(subject.status).to be_an(Integer) }
         it { expect(subject.status).to eq(21002) }
      end

      context "#validate!" do
         it { expect { subject.validate! }.to raise_error(Itunes::Receipt::InvalidReceiptFormatError) }
      end
   end


   describe "iTunes invalid receipt JSON" do
      subject do
         service = Itunes::Receipt::Service.new(host: Itunes::Receipt::Service::TEST_HOST,
                                                password: invalid_password)

         service.validate(receipt_data: receipt_data_v1)
      end

      it { is_expected.to be_a(Itunes::Receipt::Response) }
      it { expect(subject).to_not be_valid }

      context "#request" do
         it { expect(subject.request).to be_a(Hash) }
      end

      context "#response" do
         it { expect(subject.response).to be_a(Excon::Response) }
      end

      context "#receipt" do
         it { expect(subject.latest_receipt).to be_nil }
      end

      context "#latest_receipt" do
         it { expect(subject.latest_receipt).to be_nil }
      end

      context "#data" do
         it { expect(subject.data).to be_a(Hash) }
      end

      context "#status" do
         it { expect(subject.status).to be_an(Integer) }
         it { expect(subject.status).to eq(21004) }
      end

      context "#validate!" do
         it { expect { subject.validate! }.to raise_error(Itunes::Receipt::InvalidSharedSecretError) }
      end
   end

   describe "iTunes valid receipt v2 response" do
      subject do
         service = Itunes::Receipt::Service.new(host: Itunes::Receipt::Service::TEST_HOST,
                                                password: password)

         service.validate(receipt_data: receipt_data_v2)
      end

      it { is_expected.to be_a(Itunes::Receipt::Response) }
      it { expect(subject).to be_valid }

      context "#request" do
         it { expect(subject.request).to be_a(Hash) }
      end

      context "#response" do
         it { expect(subject.response).to be_a(Excon::Response) }
      end

      context "#receipt" do
         it { expect(subject.latest_receipt).to be_a(Itunes::Receipt::V2) }
      end

      context "#latest_receipt" do
         it { expect(subject.latest_receipt).to be_a(Itunes::Receipt::V2) }
      end

      context "#receipts" do
         it { expect(subject.receipts).to be_a(Array) }
         it { expect(subject.receipts.first).to be_a(Itunes::Receipt::V2) }
      end

      context "#data" do
         it { expect(subject.data).to be_a(Hash) }
      end

      context "#status" do
         it { expect(subject.status).to be_an(Integer) }
         it { expect(subject.status).to eq(0) }
      end

      context "#validate!" do
         it { expect(subject.validate!).to be_truthy }
      end
   end

end
