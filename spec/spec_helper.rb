require "pry"
require "vcr"
require "timecop"
require "bundler/setup"
require "itunes/receipt"

VCR.configure do |config|
   config.cassette_library_dir = "spec/fixtures/vcr"
   config.hook_into :webmock
   config.default_cassette_options = {
      record: :new_episodes,
      match_requests_on: [:method, :host, :path, :body]
   }
end

RSpec.configure do |config|
   # Enable flags like --only-failures and --next-failure
   config.example_status_persistence_file_path = ".rspec_status"

   config.expect_with :rspec do |c|
      c.syntax = :expect
   end

   config.before(:each) do
      VCR.insert_cassette(:itunes)
   end

   config.after(:each) do
      VCR.eject_cassette
      Timecop.return
   end
end
