require_relative 'data_collection'

class Games < DataCollection
  def self.from_csv(file_location, active_data)
    DataCollection.from_csv(file_location, Games, active_data)
  end

  def data_type
    Game
  end
end


class Game
  attr_reader :id,
              :home_goals,
              :away_goals,
              :season_id,
              :home_team_id,
              :away_team_id

  def initialize(game_data, active_data)
    @active_data = active_data
    @id = game_data['game_id']
    @season_id = game_data['season']
    @home_goals = game_data['home_goals'].to_i
    @away_goals = game_data['away_goals'].to_i
    @home_team_id = game_data['home_team_id']
    @away_team_id = game_data['away_team_id']
  end

  def total_goals
    home_goals + away_goals
  end

  def home_win?
    home_goals > away_goals
  end

  def away_win?
    away_goals > home_goals
  end

  def tie?
    home_goals == away_goals
  end

  # def winning_team
  #   @winning_team ||= @active_data.teams.find {|t| t.id == home_team_id}
  # end
end