require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Elephant::Cache" do

  class Point
    include Elephant::Cache

    def initialize(x=0, y=0)
      initialize_cache
      self.x = x
      self.y = y
      @magnitude_calc_count = 0
    end

    attr_reader :x, :y

    def magnitude
      return cache_value(__method__) do
        @magnitude_calc_count += 1
        Math.sqrt(self.x**2 + self.y**2)
      end
    end

    def x=(x)
      dirty_cache(:magnitude)
      @x = x
    end

    def y=(y)
      dirty_cache() # Purposefully dump whole cache for testing.
      @y = y
    end

  end

  it 'should be private' do
    klass = Class.new
    klass.send(:include, Elephant::Cache)

    Elephant::Cache.instance_methods.each do |method|
      klass.private_methods.should include(method)
    end
  end

  it 'should cache a value' do
    # Make a point.
    p = Point.new(3,4)
    p.instance_variable_get(:@elephant_cache)[:magnitude].should == nil
    p.instance_variable_get(:@magnitude_calc_count).should == 0

    # Calculate a cached var
    m = p.magnitude
    m.should_not be_nil
    p.instance_variable_get(:@elephant_cache)[:magnitude].should == m
    p.instance_variable_get(:@magnitude_calc_count).should == 1
    
    # Make sure it doesn't recalculate on fetch.
    m = p.magnitude
    m.should_not be_nil
    p.instance_variable_get(:@elephant_cache)[:magnitude].should == m
    p.instance_variable_get(:@magnitude_calc_count).should == 1 
  end

  it 'should dirty' do
    # Make a point.
    p = Point.new(3,4)
    p.instance_variable_get(:@elephant_cache)[:magnitude].should == nil
    p.instance_variable_get(:@magnitude_calc_count).should == 0

    # Calculate a cached var
    m = p.magnitude
    m.should_not be_nil
    p.instance_variable_get(:@elephant_cache)[:magnitude].should == m
    p.instance_variable_get(:@magnitude_calc_count).should == 1

    # Now clear the cache.
    p.x = 30
    p.y = 40
    p.instance_variable_get(:@elephant_cache)[:magnitude].should == nil
    
    # See if it recalculated
    m = p.magnitude
    m.should_not be_nil
    p.instance_variable_get(:@elephant_cache)[:magnitude].should == m
    p.instance_variable_get(:@magnitude_calc_count).should == 2
  end

end
