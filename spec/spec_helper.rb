require 'bundler/setup'
require 'rack/auth/travis_webhook'
require 'rack/test'
require 'vcr'
require 'webmock/rspec'

RSpec.configure do |config|
  config.include(Rack::Test::Methods)

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with(:rspec) do |c|
    c.syntax = :expect
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into(:webmock)
  c.configure_rspec_metadata!
end

def app
  @app ||= Rack::Builder.new do
    use Rack::Auth::TravisWebhook
    run ->(_env) { [200, {}, []] }
  end
end

class StubKey
  def initialize
    @key = OpenSSL::PKey::RSA.new(2048)
    config = {
      config: {
        notifications: { webhook: { public_key: @key.public_key.to_pem } }
      }
    }
    WebMock::API.stub_request(
      :get, Rack::Auth::TravisWebhook::TRAVIS_CONFIG_URL
    ).to_return(body: JSON.dump(config))
  end

  def sign(payload)
    Base64.encode64(@key.sign(OpenSSL::Digest::SHA1.new, payload))
  end
end
