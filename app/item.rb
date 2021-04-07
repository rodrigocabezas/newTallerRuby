class Item
  attr_accessor :key, :value, :ttl, :expiration, :flags, :cas

  Default = 60 * 60 * 24 * 365 * 10
  def initialize(key, flags, ttl, value)
    @key = key
    @flags = flags
    @ttl = ttl
    # @bytes = bytes
    @value = value
    @cas = 1
    @expiration = ttl === 0 ? Time.now + Default : Time.now + ttl
  end
end
