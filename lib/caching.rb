Dir["#{File.dirname(__FILE__)}/caching/*.rb"].each { |file| require file }
require 'set'
require 'base64'

module Caching

  module ClassMethods

    def cache_method(method)
      alias_method "#{method}_without_cache", method

      define_method method do |*args, &block|
        args_key = args.any? ? "_#{Base64.encode64(Marshal.dump(args))}" : ''
        method_key = "#{method}#{args_key}"
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
      @cached_methods_keys ||= Hash.new {|h,k| h[k] = Set.new}
    end

    def clear_cache(*methods)
      method_keys = cached_methods_keys.
        select{ |m,_| methods.include? m }.
        flat_map{ |_,keys| keys.to_a }
      cache_storage.clear *method_keys
      method_keys.each { |k| cached_methods_keys.delete k }
    end

  end

end

Object.send :extend, Caching::ClassMethods
Object.send :include, Caching::InstanceMethods
