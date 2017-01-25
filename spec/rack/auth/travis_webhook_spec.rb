require 'base64'
require 'json'
require 'spec_helper'

RSpec.describe Rack::Auth::TravisWebhook do
  it 'has a version number' do
    expect(Rack::Auth::TravisWebhook::VERSION).not_to be nil
  end

  it 'returns unauthorized when signature not provided', :vcr do
    post('/')
    expect(last_response).to be_unauthorized
  end

  it 'returns forbidden when signature is invalid', :vcr do
    post('/', { payload: '{}' }, 'HTTP_SIGNATURE' => '12345678')
    expect(last_response).to be_forbidden
  end

  it 'returns bad request when payload is missing', :vcr do
    post('/', {}, 'HTTP_SIGNATURE' => '12345678')
    expect(last_response).to be_bad_request
  end

  it 'returns method not allowed on a get request', :vcr do
    key = StubKey.new
    payload = JSON.dump(garbage_in: :garbage_out)
    get('/', { payload: payload }, 'HTTP_SIGNATURE' => key.sign(payload))
    expect(last_response).to be_method_not_allowed
  end

  it 'calls next handler when signature is valid' do
    key = StubKey.new
    payload = JSON.dump(garbage_in: :garbage_out)
    post('/', { payload: payload }, 'HTTP_SIGNATURE' => key.sign(payload))
    expect(last_response).to be_ok
  end
end
