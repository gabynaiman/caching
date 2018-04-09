module Caching
  class Storage
    
    def initialize
      @storage = {}
      @lock = Mutex.new
    end

    def read(key)
      @lock.synchronize { @storage[key] }
    end

    def write(key, value)
      @lock.synchronize { @storage[key] = value } 
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