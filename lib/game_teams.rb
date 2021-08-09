class GameTeams < DataCollection
  def self.from_csv(file_location, active_data)
    DataCollection.from_csv(file_location, GameTeams, active_data)
  end

  def data_type
    GameTeam
  end
end

class GameTeam
  attr_reader :id, :game_id, :result, :head_coach, :team_id, :shots, :goals

  def initialize(game_team_data, active_data)
    @active_data = active_data
    @id = game_team_data['game_id']
    @game_id = id
    @result = game_team_data['result']
    @head_coach = game_team_data['head_coach']
    @team_id = game_team_data['team_id']
    @shots = game_team_data['shots'].to_i
    @goals = game_team_data['goals'].to_i
  end

  def game
    @game ||= @active_data.games.get(id)
  end

  def season_id
    game.season_id
  end

  def win?
    result == 'WIN'
  end

  # def team
  #   @active_data.teams.get(team_id)
  # end
end