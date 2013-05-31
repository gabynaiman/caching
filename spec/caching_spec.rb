require 'minitest_helper'

describe Caching do
  
  class Cachable

    def initialize
      @slow_method = 0
      @slow_method_with_args = 0
      @fast_method = 0
    end

    def slow_method
      @slow_method += 1
    end
    cache_method :slow_method

    def slow_method_with_args(arg)
      @slow_method_with_args += 1
    end
    cache_method :slow_method_with_args

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
    3.times { object.slow_method_with_args([1]).must_equal 1 }
    3.times { object.slow_method_with_args('text').must_equal 2 }
    object.fast_method.must_equal 1
    object.fast_method.must_equal 2
  end

  it 'Clear cache for all methods' do
    object = Cachable.new

    3.times { object.slow_method.must_equal 1 }
    3.times { object.slow_method_with_args([1]).must_equal 1 }
    3.times { object.slow_method_with_args('text').must_equal 2 }

    object.clear_cache

    object.slow_method.must_equal 2
    object.slow_method_with_args(3).must_equal 3
  end

  it 'Clear cache for specific method' do
    object = Cachable.new

    3.times { object.slow_method.must_equal 1 }
    3.times { object.slow_method_with_args([1]).must_equal 1 }
    3.times { object.slow_method_with_args('text').must_equal 2 }

    object.clear_cache :slow_method

    object.slow_method.must_equal 2
    object.slow_method_with_args([1]).must_equal 1
    object.slow_method_with_args('text').must_equal 2
  end

  it 'Clear cache for specific method with arguments' do
    object = Cachable.new

    3.times { object.slow_method.must_equal 1 }
    3.times { object.slow_method_with_args([1]).must_equal 1 }
    3.times { object.slow_method_with_args('text').must_equal 2 }

    object.clear_cache :slow_method_with_args

    object.slow_method.must_equal 1
    object.slow_method_with_args([1]).must_equal 3
    object.slow_method_with_args('text').must_equal 4
  end

  it 'Clear cache inside object' do
    object = Cachable.new

    3.times { object.slow_method.must_equal 1 }
    3.times { object.slow_method_with_args([1]).must_equal 1 }
    3.times { object.slow_method_with_args('text').must_equal 2 }

    object.reset

    object.slow_method.must_equal 2
    object.slow_method_with_args([1]).must_equal 3
    object.slow_method_with_args('text').must_equal 4
  end

end