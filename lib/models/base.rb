require_relative 'collection'
require 'forwardable'

class BaseModel
  class << self
    extend Forwardable
    def_delegators :@data, :all,
                           :find,
                           :count, 
                           :group, 
                           :average, 
                           :maximum, 
                           :minimum
  end

  def self.load(file_location)
    @file_location = file_location
    @data = Collection.new(file_location, self)
  end
end