require_relative 'games'
require_relative 'teams'
require_relative 'game_teams'
require_relative 'seasons'

class ActiveData
  attr_reader :games, :teams, :game_teams, :seasons

  def self.from_csv(file_locations)
    ActiveData.new(file_locations)
  end

  def initialize(file_locations)
    @games = Games.from_csv(file_locations[:games], self)
    @teams = Teams.from_csv(file_locations[:teams], self)
    @seasons = Seasons.from_active_data(self)
    @game_teams = GameTeams.from_csv(file_locations[:game_teams], self)
  end
end