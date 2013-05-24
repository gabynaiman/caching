Dir["#{File.dirname(__FILE__)}/caching/*.rb"].each { |file| require file }

module Caching

  def self.extended(klass)
    constructor = klass.method :new

    klass.define_singleton_method :new do |*args, &block|
      instance = constructor.call(*args, &block)
      proxy = Proxy.new instance, *@cached_methods

      instance.send :define_singleton_method, :clear_cache do
        proxy.clear_cache
      end

      proxy
    end
  end

  def cache(*methods)
    @cached_methods = (@cached_methods ||= []) | methods.map(&:to_sym).uniq
  end

end