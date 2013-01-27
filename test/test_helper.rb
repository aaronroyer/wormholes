require 'rubygems'
require 'minitest/autorun'

require File.join(File.dirname(__FILE__), *%w[.. lib wormholes])

GOOD_WORMHOLE_NAMES = %w[name a johnny5 500 2 default]
BAD_WORMHOLE_NAMES = ['', 'two words', 'weird(name)', '#name', 'myemail@aol.com']
