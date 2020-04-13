$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "wac"
require "vcr"

require "minitest/autorun"

class Minitest::Test
  def read_fixture(fixture_file)
    File.read("#{__dir__}/fixtures/#{fixture_file}")
  end

  def write_fixture(fixture_file, content)
    File.open("#{__dir__}/fixtures/#{fixture_file}", "w") do |f|
      f.write content
    end
  end
end

# vcr
VCR.configure do |config|
  config.cassette_library_dir = "#{__dir__}/fixtures/vcr_cassettes"
  config.hook_into :webmock
end
