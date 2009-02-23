#!/usr/bin/ruby

require 'moranis'
require 'time'

class MockKeys < MoranisKeys
  attr_writer :time
  attr_writer :number

  def get_time
    @time
  end
  
  # This will always be 2^32 - 1
  def random(number)
    @number || number
  end
end

class MoranisKeysTest < Test::Unit::TestCase
  def setup
    @moranis = MockKeys.new
  end

  def test_time_is_positive
    @moranis.time = Time.parse('2009-01-21').to_i
    assert @moranis.generate > 0
  end
  
  def test_key_is_equal_to_pregenerated
    expected = 530242875519139839
    @moranis = MockKeys.new
    @moranis.time = 123456789
    actual = @moranis.generate
    assert_equal "123456789:4294967295", MoranisKeys.to_s(actual)
    assert_equal expected, actual
  end

  def test_key_is_equal_to_pregenerated_with_0_number
    expected = 530242871224172544
    @moranis = MockKeys.new
    @moranis.time = 123456789
    @moranis.number = 0
    actual = @moranis.generate
    assert_equal "123456789:0", MoranisKeys.to_s(actual)
    assert_equal expected, actual
  end
  
  def test_key_is_equal_to_pregenerated_with_0_time
    expected = 4294967295
    @moranis = MockKeys.new
    @moranis.time = 0
    actual = @moranis.generate
    assert_equal "0:4294967295", MoranisKeys.to_s(actual)
    assert_equal expected, actual
  end

  def test_both_at_lower_boundary
    @moranis = MockKeys.new
    @moranis.time = 0
    @moranis.number = 0
    actual = @moranis.generate
    assert_equal 0, actual
  end
  
  def test_time_at_lower_boundary
    @moranis = MockKeys.new
    @moranis.time = 0
    actual = @moranis.generate
    assert_equal 0xFFFFFFFF, actual
  end
  
  def test_number_at_lower_boundary
    @moranis = MockKeys.new
    @moranis.time = 0xFFFFFFFF
    @moranis.number = 0
    actual = @moranis.generate
    assert_equal 0xFFFFFFFF00000000, actual
  end
end

require 'test/unit/ui/console/testrunner'
Test::Unit::UI::Console::TestRunner.run(MoranisKeysTest)
