require 'socket'

module Wormholes
  class Hole
    include Utilities

    attr_accessor :name

    def initialize(opts={})
      @name = opts[:name] ? test_wormhole_name(opts[:name]) : 'default'
      @socket_file = opts[:socket_file] || File.join(::Wormholes.socket_dir, "#{@name}.sock")
      @output_stream = opts[:output_stream] || $stdout
      @socket = nil
    end

    def open
      @socket = UNIXSocket.new(@socket_file)
    end

    def close
      @socket.close
    end

    def listen
      begin
        while listen_for_next_line
          # no-op
        end
      rescue Interrupt
        close
      end
    end

    def listen_for_next_line
      line = @socket.gets
      @output_stream.puts line
      line
    end
  end
end
