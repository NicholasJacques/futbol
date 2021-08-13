require 'csv'
require_relative 'base'

class Game < BaseModel
  attr_reader :id, :season_id, :home_goals, :away_goals, :away_team_id, :home_team_id

  #@@file_location = ""
  #@@count = 0

  def initialize(raw_data)
    #puts("banana")
    #@@count += 1
    #puts(@@count)
    @id           = raw_data['game_id']
    @home_goals   = raw_data['home_goals'].to_i
    @away_goals   = raw_data['away_goals'].to_i
    @season_id    = raw_data['season']
    @home_team_id = raw_data['home_team_id']
    @away_team_id = raw_data['away_team_id']
    # Game.all << self
    # Game.lookup[id] = self
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

end