class GameTeam < BaseModel
  attr_reader :team_id, :goals

  def initialize(raw_data)
    @team_id = raw_data['team_id']
    @goals = raw_data['goals'].to_i
  end
end