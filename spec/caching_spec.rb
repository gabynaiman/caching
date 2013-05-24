require 'minitest_helper'

describe Caching do
  
  class Cachable
    extend Caching
    cache :slow_method, :other_slow_method

    def initialize
      @slow_method = 0
      @other_slow_method = 0
      @fast_method = 0
    end

    def slow_method
      @slow_method += 1
    end

    def other_slow_method
      @other_slow_method += 1
    end

    def fast_method
      @fast_method += 1
    end

    def reset
      clear_cache
    end
  end

  it 'Cache methods' do
    object = Cachable.new

    3.times { object.slow_method.must_equal 1 }
    3.times { object.other_slow_method.must_equal 1 }
    object.fast_method.must_equal 1
    object.fast_method.must_equal 2
  end

  it 'Clear cache for all methods' do
    object = Cachable.new

    3.times { object.slow_method.must_equal 1 }
    3.times { object.other_slow_method.must_equal 1 }

    object.clear_cache

    object.slow_method.must_equal 2
    object.other_slow_method.must_equal 2
  end

  it 'Clear cache for specific method' do
    object = Cachable.new

    3.times { object.slow_method.must_equal 1 }
    3.times { object.other_slow_method.must_equal 1 }

    object.clear_cache :slow_method

    object.slow_method.must_equal 2
    object.other_slow_method.must_equal 1
  end

  it 'Clear cache inside object' do
    object = Cachable.new

    3.times { object.slow_method.must_equal 1 }
    3.times { object.other_slow_method.must_equal 1 }

    object.reset

    object.slow_method.must_equal 2
    object.other_slow_method.must_equal 2
  end

end