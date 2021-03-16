class Item
    attr_accessor :key
    attr_accessor :value
    attr_accessor :ttl
    attr_accessor :expiration
    attr_accessor :bytes
    attr_accessor :flags
    attr_accessor :cas
  
    def initialize(key,flags,ttl,bytes,value)
      @key = key
      @flags = flags
      @ttl = ttl
      @bytes = bytes
      @value = value
      @cas = 1
      ttl === 0 ? @expiration = Time.now + (60*60*24*365*10): @expiration = Time.now + ttl
    end
  end