require_relative 'base'

class Team < BaseModel
  attr_reader :id, :name

  def initialize(raw_data)
    @id = raw_data['team_id']
    @name = raw_data['teamName']
  end
end
