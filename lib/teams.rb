require_relative 'data_collection'

class Teams < DataCollection
  def self.from_csv(file_location, active_data)
    DataCollection.from_csv(file_location, Teams, active_data)
  end

  def data_type
    Team
  end
end

class Team
  attr_reader :id, :name

  def initialize(team_data, active_data)
    @active_data = active_data
    @id = team_data['team_id']
    @name = team_data['teamName']
  end

  def games
    @games ||= @active_data.games.find_all {|g| [g.home_team_id, g.away_team_id].include?(self.id)}
  end

  def away_games
    @away_games ||= games.find_all {|g| g.away_team_id == self.id}
  end

  def home_games
    @home_games ||= games.find_all {|g| g.home_team_id == self.id}
  end

  def average_goals_per_game
    total_goals = games.reduce(0) do |sum, game|
      if game.home_team_id == self.id
        sum + game.home_goals
      else
        sum + game.away_goals
      end
    end

    (total_goals / games.length.to_f).round(2)
  end

  def average_goals_while_away
    total_goals = away_games.reduce(0) {|sum, g| sum + g.away_goals}

    (total_goals / games.length.to_f).round(2)
  end

  def average_goals_while_home
    total_goals = home_games.reduce(0) {|sum, g| sum + g.home_goals}
    
    (total_goals / games.length.to_f).round(2)
  end
end