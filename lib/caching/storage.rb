module Caching
  class Storage
    
    def initialize
      @storage = {}
      @lock = Mutex.new
    end

    def read(key)
       @storage[key]
    end

    def write(key, value)
      @lock.synchronize { set key, value }
    end

    def fetch(key)
      if @lock.owned?
        read(key) || set(key, yield)
      else
        @lock.synchronize { read(key) || set(key, yield) }
      end
    end

    def clear(*keys)
      if keys.empty?
        @storage = {}
      else
        keys.each { |k| @storage.delete k }
      end
    end

    private

    def set(key, value)
      @storage[key] = value
    end

  end
end