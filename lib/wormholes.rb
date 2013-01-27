require 'wormholes/version'
require 'wormholes/utilities'
require 'wormholes/worm'
require 'wormholes/hole'

module Wormholes
  NAME_REGEX = /^[\w\d_-]+$/i

  def self.socket_dir
    ENV['WORMHOLES_SOCKET_DIR'] || File.join(ENV['HOME'], '.wormholes-sockets')
  end
end
