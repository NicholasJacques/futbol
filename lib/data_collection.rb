class DataCollection
  include Enumerable
  attr_accessor :lookup

  def self.from_csv(file_location, klass, active_data)
    collection = klass.new
    CSV.foreach(file_location, headers: true) do |row|
      item = collection.data_type.new(row, active_data)
      collection << collection.data_type.new(row, active_data)
      collection.lookup[item.id] = item
    end
    collection
  end

  # def self.from_active_data(klass, active_data)
  #   collection = klass.new
  #   active_data.games.unique {|g| g.season}.each do |season|
  #     collection << collection.data_type.new(season, active_data)
  
  #   end
  #   collection
  # end

  def initialize(collection=[])
    @collection = collection
    @lookup = {}
  end

  def to_s
    @collection.join(" ")
  end

  def <<(item)
    if item.instance_of?(self.data_type)
      @collection << item
    else
      raise(TypeError("Must match type"))
    end
  end

  def each(*args, &block)
    @collection.each(*args, &block)
  end

  def length
    @collection.length
  end
  alias_method :size, :length

  def get(id)
    lookup[id]
  end
end