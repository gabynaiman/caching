module Caching
  class Storage
    
    def initialize
      @storage = Concurrent::Hash.new
      @lock = Mutex.new
    end

    def read(key)
       @storage[key]
    end

    def write(key, value)
      @storage[key] = value
    end

    def fetch(key)
      read(key) || write(key, yield)
    end

    def clear(*keys)
      if keys.empty?
        @storage = {}
      else
        keys.each { |k| @storage.delete k }
      end
    end

  end
end