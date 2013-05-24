require 'minitest_helper'

describe Caching::Storage do

  it 'Write and Read' do
    storage = Caching::Storage.new
    storage.write :key_1, 'value_1'
    storage.write :key_2, 'value_2'

    storage.read(:key_1).must_equal 'value_1'
    storage.read(:key_2).must_equal 'value_2'
  end

  it 'Fetch' do
    storage = Caching::Storage.new
    number = 0

    storage.fetch(:key) { number += 1 }.must_equal 1
    storage.fetch(:key) { number += 1 }.must_equal 1
    number.must_equal 1
  end

  it 'Clear all' do
    storage = Caching::Storage.new
    storage.write :key_1, 'value_1'
    storage.write :key_2, 'value_2'
    
    storage.clear

    storage.read(:key_1).must_be_nil
    storage.read(:key_2).must_be_nil
  end

  it 'Clear specific keys' do
    storage = Caching::Storage.new
    storage.write :key_1, 'value_1'
    storage.write :key_2, 'value_2'
    storage.write :key_3, 'value_3'
    
    storage.clear :key_1, :key_3

    storage.read(:key_1).must_be_nil
    storage.read(:key_2).must_equal 'value_2'
    storage.read(:key_3).must_be_nil
  end

end