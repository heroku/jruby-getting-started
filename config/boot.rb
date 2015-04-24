# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

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
