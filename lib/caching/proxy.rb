module Caching
  class Proxy
  
    instance_methods.each { |m| undef_method m unless m =~ /(^__|^send$|^object_id$)/ }

    def initialize(target, *methods)
      @target = target
      @methods = methods.map(&:to_sym)
      @storage = Storage.new
    end

    def method_missing(method, *args, &block)
      if @methods.include? method.to_sym
        @storage.fetch(method) { @target.send(method, *args, &block) }
      else
        @target.send(method, *args, &block)
      end
    end

    def clear_cache(*methods)
      @storage.clear *methods
    end

  end
end