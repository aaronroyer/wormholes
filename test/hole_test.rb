require File.expand_path('../test_helper', __FILE__)

class HoleTest < MiniTest::Unit::TestCase
  def test_proper_wormhole_names_are_enforced
    GOOD_WORMHOLE_NAMES.each {|name| Wormholes::Hole.new :name => name }
    BAD_WORMHOLE_NAMES.each do |name|
        assert_raises(ArgumentError) { Wormholes::Hole.new :name => name }
    end
  end
end
