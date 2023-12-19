class GameTeam < BaseModel
  attr_reader :team_id, :goals, :coach, :result

  def initialize(raw_data)
    @team_id = raw_data['team_id']
    @goals = raw_data['goals'].to_i
    @coach = raw_data['coach']
    @result = raw_data['result']
  end
end