require 'rubygems'
require 'minitest/autorun'
require 'json'

class TestFilterExternal < MiniTest::Unit::TestCase
  include SensuPluginTestHelper

  def setup
    set_script 'external/handle-filter'
  end

  def test_resolve_not_enough_occurrences
    event = {
      'client' => { 'name' => 'test' },
      'check' => { 'name' => 'test', 'occurrences' => 2},
      'occurrences' => 1
    }
    output = run_script_with_input(JSON.generate(event))
    assert_equal(0, $?.exitstatus)
    assert_match(/^not enough occurrences/, output)
  end

  def test_resolve_enough_occurrences
    event = {
      'client' => { 'name' => 'test' },
      'check' => { 'name' => 'test', 'occurrences' => 2},
      'occurrences' => 3
    }
    output = run_script_with_input(JSON.generate(event))
    assert_equal(0, $?.exitstatus)
    assert_match(/^Event:/, output)
  end

  def test_resolve_enough_occurrences_exactly
    event = {
      'client' => { 'name' => 'test' },
      'check' => { 'name' => 'test', 'occurrences' => 2},
      'occurrences' => 2
    }
    output = run_script_with_input(JSON.generate(event))
    assert_equal(0, $?.exitstatus)
    assert_match(/^Event:/, output)
  end
end
