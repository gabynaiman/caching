Dir["#{File.dirname(__FILE__)}/caching/*.rb"].each { |file| require file }

module Caching

  def self.extended(klass)
    constructor = klass.method :new

    klass.define_singleton_method :new do |*args, &block|
      Proxy.new constructor.call(*args, &block), *@cached_methods
    end
  end

  def cache(*methods)
    @cached_methods = (@cached_methods ||= []) | methods.map(&:to_sym).uniq
  end

end