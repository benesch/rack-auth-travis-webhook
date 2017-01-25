# Rack::Auth::TravisWebhook

Rack middleware to [verify Travis CI webhook requests][0].

[0]: https://docs.travis-ci.com/user/notifications/#Verifying-Webhook-requests

## Usage

```ruby
require 'rack/auth/travis_webhook'

Rack::Builder.new do
  use Rack::Auth::TravisWebhook
  run ->(_env) { [200, {}, ["If you can see me, you must be Travis!"]] }
end
```
