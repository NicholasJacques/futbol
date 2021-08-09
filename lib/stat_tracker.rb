require 'csv'
require_relative 'active_data'

class StatTracker

    def self.from_csv(file_locations)
        StatTracker.new(file_locations)
    end

    def initialize(file_locations)
        @data = ActiveData.from_csv(file_locations)
    end

    def games
        @data.games
    end

    def teams
        @data.teams
    end

    def seasons
        @data.seasons
    end

    # Game Statistics

    def highest_total_score
        games.max_by {|g| g.home_goals + g.away_goals}.total_goals
    end

    def lowest_total_score
        games.min_by {|g| g.home_goals + g.away_goals}.total_goals
    end

    def percentage_home_wins
        games.reduce {|g|  }
        (games.count {|g| g.home_win? } / games.length.to_f).round(2)
    end

    def percentage_visitor_wins
        (games.count {|g| g.away_win? } / games.length.to_f).round(2)
    end

    def percentage_ties
        (games.count {|g| g.tie? } / games.length.to_f).round(2)
    end
    
    def count_of_games_by_season
        games.reduce(Hash.new(0)) do |seasons, game| 
            seasons[game.season_id] += 1
            seasons
        end
    end

    def average_goals_per_game
        total_goals = games.reduce(0) do |sum, game| 
            sum + game.total_goals
        end
        (total_goals / games.length.to_f).round(2)
    end

    def average_goals_by_season
        seasons = Hash.new { |hash, key| hash[key] = { total_games: 0, total_goals: 0 } }
        games.reduce(seasons) do |seasons, game| 
            seasons[game.season_id][:total_games] += 1
            seasons[game.season_id][:total_goals] += game.total_goals
            seasons
        end
        seasons.transform_values {|v| (v[:total_goals] / v[:total_games].to_f).round(2) }
    end

    # League Statistics

    def count_of_teams
        teams.length
    end

    def best_offense
        teams.max_by(&:average_goals_per_game).name
    end

    def worst_offense
        teams.min_by(&:average_goals_per_game).name
    end

    def highest_scoring_visitor
        teams.max_by(&:average_goals_while_away).name
    end

    def highest_scoring_home_team
        teams.max_by(&:average_goals_while_home).name
    end

    def lowest_scoring_visitor
        teams.min_by(&:average_goals_while_away).name
    end

    def lowest_scoring_home_team
        teams.min_by(&:average_goals_while_home).name
    end

    def winningest_coach(season_id)
        seasons.find{|s| s.id == season_id}.winningest_coach
    end

    def worst_coach(season_id)
        seasons.find{|s| s.id == season_id}.worst_coach
    end

    def most_accurate_team(season_id)
        seasons.find{|s| s.id == season_id}.most_accurate_team
    end

    def least_accurate_team(season_id)
        seasons.find{|s| s.id == season_id}.least_accurate_team
    end

    def most_tackles(season_id)
        seasons.find{|s| s.id == season_id}.most_tackles
    end
end

