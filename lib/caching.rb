Dir["#{File.dirname(__FILE__)}/caching/*.rb"].each { |file| require file }

module Caching

  module ClassMethods

    def cache_method(method)
      alias_method "#{method}_without_cache", method

      define_method method do |*args, &block|
        method_key = "#{method}_#{Marshal.dump(args)}"
        cached_methods_keys[method] << method_key
        cache_storage.fetch(method_key) { send "#{method}_without_cache", *args, &block }
      end
    end

  end

  module InstanceMethods

    def cache_storage
      @cache_storage ||= Storage.new
    end

    def cached_methods_keys
      @cached_methods_keys ||= Hash.new {|h,k| h[k] = []}
    end

    def clear_cache(*methods)
      method_keys = cached_methods_keys.
        select{ |m,_| methods.include? m }.
        flat_map{ |_,keys| keys }

      cache_storage.clear *method_keys
    end

  end

end

Object.send :extend, Caching::ClassMethods
Object.send :include, Caching::InstanceMethods
