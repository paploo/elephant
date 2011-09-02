module Elephant
  # A simple caching API.
  #
  # To use, initialize the cache in your object initialize method, then
  # simply call <code>cache(:lookup_key){...}</code> with the block generating the value
  # that should be cached.  From then on, it'll use the cached value (unless
  # you dirty the cache, of course).
  #
  # If you want to access a cached value outside of where it is created, it is
  # best to cache the value in an accessor method and then call the accessor.
  #
  # Note: Outside of initialize_cache, the APIs are designed in a way that
  # easily facilitates using any cache store, as long as it has hash-like access.
  # Thus, one could make a mapper to Memcache or Mongo and override initialize_cache
  # with a new implementation before calling it, and you'd be able to store anywhere.
  module Cache

    private

    # Initializes the cache.  This should be called in your object's initialize
    # method.  Note that this can be overriden to use any hash-like object you
    # want as a cache store, allowing use of Memcache, Mongo, or SQL.
    def initialize_cache
      @elephant_cache = {}
    end
    
    # Retrieves the value for the given key from the cache, calculating it from
    # the block if necessary.
    #
    # Ex:
    #  def foo
    #    return cache_value(__method__) { ...do a lot of work... }
    #  end
    def cache_value(key)
      unless(@elephant_cache.include?(key))
        start_at = Time.now
        @elephant_cache[key] = yield if block_given?
        stop_at = Time.now
        delta_t = stop_at - start_at
        if( Elephant.time? )
          label = "#{self.class.name} - #{key}"
          Elephant.time_io.puts " -- #{label.to_s.rjust(32)}: #{('%0.3f' % (delta_t*1000.0)).rjust(9)} ms (#{caller[0]})"
        end
      end
      return @elephant_cache[key]
    end
    
    # Given a key, it dirties the cache for that key so that the next access
    # will recalculate it.  If no key is given, it cleas the entire cache.
    def dirty_cache(key=nil)
      if(key.nil?)
        @elephant_cache.clear
      else
        @elephant_cache.delete(key)
      end
    end

  end
end
