require "spec_helper"

RSpec.describe Itunes::Receipt::Service do
   let(:password) { '6a9f8013214345a5ad3d3f13462083c1' }
   let(:receipt_data_v1) { Base64.encode64(IO.read('spec/fixtures/files/kvitok_for_year.json')) }

   describe "iTunes valid receipt" do
      context "service" do
         subject { described_class.new(host: Itunes::Receipt::Service::TEST_HOST, password: password) }

         it { is_expected.to be_a(Itunes::Receipt::Service) }
         context "#host" do
            it { expect(subject.host).to eq(Itunes::Receipt::Service::TEST_HOST) }
         end

         context "#password" do
            it { expect(subject.password).to eq(password) }
         end

         context "#connection" do
            it { expect(subject.connection).to be_a(Excon::Connection) }
            it { expect(subject.connection.data[:port]).to eq(443) }
            it { expect(subject.connection.data[:scheme]).to eq('https') }
         end

         context "#validate" do
            it { expect(subject.validate(receipt_data: receipt_data_v1)).to be_a(Itunes::Receipt::Response) }
         end
      end
   end
end
