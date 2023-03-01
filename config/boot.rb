ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

require 'java'

java_import javax.crypto.Cipher
java_import java.security.NoSuchAlgorithmException

is_unlimited_jce = true
begin
  strength = Cipher.getMaxAllowedKeyLength("AES")
  is_unlimited_jce = strength > 128
rescue NoSuchAlgorithmException => nsae
  is_unlimited_jce = false
ensure
  unless is_unlimited_jce
    security_class = java.lang.Class.for_name('javax.crypto.JceSecurity')
    restricted_field = security_class.get_declared_field('isRestricted')
    restricted_field.accessible = true
    restricted_field.set nil, false
  end
end
