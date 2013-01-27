require File.expand_path('../test_helper', __FILE__)
require 'fileutils'
require 'tmpdir'
require 'stringio'

# Test wormholes using normal UNIX domain sockets
class SocketWormholeTest < MiniTest::Unit::TestCase
  def setup
    @tmp_dir = File.join( Dir.tmpdir, "wormholes-tests-#{(0...10).map{ ('a'..'z').to_a[rand(26)] }.join}")
    Dir.mkdir(@tmp_dir)
  end

  def teardown
    FileUtils.rm_rf @tmp_dir
  end

  def test_a_line_can_be_sent
    test_str = "this is what we will send\n"
    str_io = StringIO.new

    ENV['WORMHOLES_SOCKET_DIR'] = @tmp_dir
    worm = Wormholes::Worm.new
    worm.open

    socket_file = File.join(@tmp_dir, 'default.sock')
    assert File.exist?(socket_file), 'the socket file has been created'
    assert File.socket?(socket_file), 'the socket file is, indeed, a socket'

    hole = Wormholes::Hole.new(:output_stream => str_io)
    hole.open

    sleep 0.01 while worm.sockets.size < 1

    thread = Thread.new { hole.listen_for_next_line }
    worm.send_to_clients test_str
    thread.join
    worm.close

    assert_equal test_str, str_io.string
  end

  def test_can_use_named_wormholes
    test_str = "we will send this through the named wormhole\n"
    str_io = StringIO.new
    wormhole_name = 'deep-space-9'

    ENV['WORMHOLES_SOCKET_DIR'] = @tmp_dir
    worm = Wormholes::Worm.new(:name => wormhole_name)
    worm.open

    socket_file = File.join(@tmp_dir, "#{wormhole_name}.sock")
    assert File.exist?(socket_file), 'the socket file has been created'
    assert File.socket?(socket_file), 'the socket file is, indeed, a socket'

    hole = Wormholes::Hole.new(:name => wormhole_name, :output_stream => str_io)
    hole.open

    sleep 0.01 while worm.sockets.size < 1

    thread = Thread.new { hole.listen_for_next_line }
    worm.send_to_clients test_str
    thread.join
    worm.close

    assert_equal test_str, str_io.string
  end
end
