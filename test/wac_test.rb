require "test_helper"

class WacTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Wac::VERSION
  end
end
