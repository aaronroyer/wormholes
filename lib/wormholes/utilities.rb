module Wormholes

  # Stuff that is needed by both ends of the wormhole
  module Utilities
    def test_wormhole_name(name)
      unless proper_wormhole_name?(name)
        raise ArgumentError, 'Wormhole name must only contain letters, numbers, hyphens, or underscores'
      end
      name
    end

    def proper_wormhole_name?(name)
      NAME_REGEX =~ name
    end
  end
end
