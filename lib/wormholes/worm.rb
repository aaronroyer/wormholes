require 'socket'
require 'fileutils'

module Wormholes
  class Worm
    include Utilities

    attr_accessor :server, :sockets, :name

    def initialize(opts={})
      @name = opts[:name] ? test_wormhole_name(opts[:name]) : 'default'
      @socket_file = opts[:socket_file] || File.join(::Wormholes.socket_dir, "#{@name}.sock")
      @sockets = []
      @server = nil

      @verbose = opts[:verbose] || false
      @debug = opts[:debug] || false
    end

    def open
      socket_dir = File.dirname(@socket_file)
      FileUtils.mkdir_p(socket_dir) unless File.directory?(socket_dir)

      File.unlink(@socket_file) if File.exist?(@socket_file) && File.socket?(@socket_file)
      @server = UNIXServer.new(@socket_file)
      accept_any_connection
      update_status
    end

    def close
      @server.close
      @server = nil
      File.unlink(@socket_file) if File.exist?(@socket_file) && File.socket?(@socket_file)
      $stderr.puts "\n...wormhole closed" if @verbose
    end

    def send_to_clients(msg)
      disconnected_sockets = []
      @sockets.each do |s|
        begin
          s.puts msg
        rescue SystemCallError => e
          $stderr.puts "Client disconnected: #{s}" if @debug
          disconnected_sockets << s
        end
      end
      unless disconnected_sockets.empty?
        @sockets = @sockets - disconnected_sockets
        debug_sockets
        update_status
      end
    end

    def send_stream(stream=$stdin)
      begin
        while line = stream.gets
          send_to_clients(line)
        end
      rescue Interrupt
        close
      end
    end

    private

    def accept_any_connection
      $worm = self
      Thread.new do
        while $worm.server
          $worm.send(:accept_connection)
        end
      end
    end

    def accept_connection
      socket = @server.accept
      add_client socket
      update_status
    end

    def add_client(socket)
      $stderr.puts "Client connected: #{socket.inspect}" if @debug
      @sockets << socket
      debug_sockets
    end

    def update_status
      return unless @verbose
      @previous_status ||= ''
      @previous_status.length.times { print "\b" }
      status = "Clients: #{sockets.size}"
      print status
      @previous_status = status
    end

    def debug_sockets
      return unless @debug
      $stderr.puts "=== Sockets ==="
      @sockets.each {|s| $stderr.puts s.inspect}
      $stderr.puts "==============="
    end
  end
end
