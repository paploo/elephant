require File.join(File.dirname(__FILE__), 'elephant', 'cache')

module Elephant

  @@time = false
  @@time_io = STDOUT

  # Used by the caches to determine if they should report the time they took to process.
  def self.time?
    return @@time ? true : false
  end

  # If set to true, the caches will report the time to process when they process.
  def self.time=(flag)
    @@time = flag ? true : false
  end

  # Returns the IO object that timing will puts to.
  def self.time_io
    return @@time_io
  end

  # Sets the IO object that timing will puts to.
  def self.time_io=(time_io)
    @@time_io = time_io
  end

end
