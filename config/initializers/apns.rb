require 'apns/core'
require 'apns/notification'
APNS.host = 'gateway.push.apple.com'
# gateway.sandbox.push.apple.com is default
APNS.pem  = '/config/cert.pem'
# this is the file you just created
APNS.port = 2195
# this is also the default. Shouldn't ever have to set this, but just in case Apple goes crazy, you can.