require 'base64'
require 'json'
require 'open-uri'
require 'openssl'
require 'rack/auth/travis_webhook/version'

module Rack
  module Auth
    class TravisWebhook
      TRAVIS_CONFIG_URL = 'https://api.travis-ci.org/config'.freeze

      def initialize(app)
        @app = app
        @public_key = fetch_public_key
      end

      def call(env)
        return status(405) unless request(env).post?
        return status(401) unless signature(env)
        return status(400) unless payload(env)
        return status(403) unless verify(env)
        @app.call(env)
      end

      private

      def request(env)
        @request ||= Rack::Request.new(env)
      end

      def signature(env)
        env['HTTP_SIGNATURE']
      end

      def payload(env)
        request(env).POST['payload']
      end

      def verify(env)
        @public_key.verify(
          OpenSSL::Digest::SHA1.new,
          Base64.decode64(signature(env)),
          payload(env)
        )
      end

      def fetch_public_key
        config = JSON.parse(open(TRAVIS_CONFIG_URL).read)
        OpenSSL::PKey::RSA.new(
          config['config']['notifications']['webhook']['public_key']
        )
      end

      def status(code)
        [code, {}, []]
      end
    end
  end
end
