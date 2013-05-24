require 'minitest_helper'

describe Caching::Proxy do
  
  class Fake
    attr_reader :x, :y

    def initialize
      @x = 0
      @y = 0
    end

    def next_x
      @x += 1
    end

    def next_y
      @y += 1
    end
  end

  it 'Cache specific method' do
    object = Fake.new
    proxy = Caching::Proxy.new object, :next_x

    proxy.next_x.must_equal 1
    proxy.next_x.must_equal 1

    proxy.next_y.must_equal 1
    proxy.next_y.must_equal 2
  end

  it 'Clear cache for all methods' do
    object = Fake.new
    proxy = Caching::Proxy.new object, :next_x, :next_y

    3.times{ proxy.next_x.must_equal 1 }
    3.times{ proxy.next_y.must_equal 1 }
    
    proxy.clear_cache

    proxy.next_x.must_equal 2
    proxy.next_y.must_equal 2
  end

  it 'Clear cache for specific method' do
    object = Fake.new
    proxy = Caching::Proxy.new object, :next_x, :next_y

    3.times{ proxy.next_x.must_equal 1 }
    3.times{ proxy.next_y.must_equal 1 }
    
    proxy.clear_cache :next_x

    proxy.next_x.must_equal 2
    proxy.next_y.must_equal 1
  end

end