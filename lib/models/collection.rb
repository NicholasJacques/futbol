require 'pry'

class Collection
  include Enumerable
  attr_accessor :grouped_value

  def initialize(file_location, klass)
    @data = CSV.foreach(file_location, headers: true)
      .lazy
      .map {|r| klass.new(r)}
    @grouped_value = nil
  end

  def all
    @data
  end

  def group(field)
    clone.tap {|c| c.grouped_value = field}
  end

  def average(field, round=0)
    if grouped_value
      keys = Hash.new { |hash, key| hash[key] = { denominator: 0, numerator: 0 } }
      self.reduce(keys) do |keys, obj| 
          keys[obj.send(grouped_value)][:denominator] += 1
          keys[obj.send(grouped_value)][:numerator] += obj.send(field)
          keys
      end
      keys.transform_values {|v| (v[:numerator] / v[:denominator].to_f).round(round) }
    else
      numerator = 0
      denominator = 0.to_f

      self.each do |obj|
        denominator += 1
        numerator += obj.send(field)
        
      end
      (numerator / denominator).round(round)
    end
  end

  def count
    if grouped_value
      self.reduce(Hash.new(0)) do |grouped_values, obj| 
        grouped_values[obj.send(grouped_value)] += 1
        grouped_values
      end
    else
      super
    end
  end

  def maximum(field)
    self.max_by {|obj| obj.send(field) }.send(field)
  end

  def each(*args, &block)
    @data.each(*args, &block)
  end

  def minimum(field)
    self.min_by {|obj| obj.send(field) }.send(field)
  end

  def find(id)
    super {|obj| obj.id == id}
  end
end
