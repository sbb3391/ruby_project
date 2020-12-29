require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

require 'bundler'
Bundler.require

require_relative '../lib/api.rb'
require_relative '../lib/cli.rb'
require_relative '../lib/team.rb'
require_relative '../lib/game.rb'