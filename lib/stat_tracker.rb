require 'csv'
require_relative './models/game'
require_relative './models/team'
require_relative './models/game_team'

class StatTracker

    def self.from_csv(file_locations)
        StatTracker.new(file_locations)
    end

    def initialize(file_locations)
        Game.load(file_locations[:games])
        Team.load(file_locations[:teams])
        GameTeam.load(file_locations[:game_teams])
    end

    # Game Statistics

    def highest_total_score
        Game.maximum(:total_goals)
    end

    def lowest_total_score
        Game.minimum(:total_goals)
    end

    def percentage_home_wins
        total_count = 0
        win_count = 0
        Game.all.each do |game|
            total_count += 1
            if game.home_win?
                win_count += 1
            end
        end

        (win_count / total_count.to_f).round(2)
    end

    def percentage_visitor_wins
        total_count = 0
        win_count = 0
        Game.all.each do |game|
            total_count += 1
            if game.away_win?
                win_count += 1
            end
        end

        (win_count / total_count.to_f).round(2)
    end

    def percentage_ties
        total_count = 0
        tie_count = 0
        Game.all.each do |game|
            total_count += 1
            if game.tie?
                tie_count += 1
            end
        end

        (tie_count / total_count.to_f).round(2)
    end
    
    def count_of_games_by_season
        Game.group(:season_id).count
    end

    def average_goals_per_game
        Game.average(:total_goals, round=2)
    end

    def average_goals_by_season
        Game.group(:season_id).average(:total_goals, round=2)
    end

    # League Statistics

    def count_of_teams
        Team.count
    end

    def best_offense
        Team.find(
            GameTeam.group(:team_id)
                .average(:goals, 2)
                .max_by { |k, v| v }[0]
        ).name
    end

    def worst_offense
        Team.find(
            GameTeam.group(:team_id)
                .average(:goals, 2)
                .min_by { |k, v| v }[0]
        ).name
    end

    def highest_scoring_visitor
        Team.find(
            Game.group(:away_team_id)
                .average(:away_goals, 2)
                .max_by { |k, v| v }[0]
        ).name
    end

    def highest_scoring_home_team
        Team.find(
            Game.group(:home_team_id)
                .average(:home_goals, 2)
                .max_by { |k, v| v }[0]
        ).name
    end

    def lowest_scoring_visitor
        Team.find(
            Game.group(:away_team_id)
                .average(:away_goals, 2)
                .min_by { |k, v| v }[0]
        ).name
    end

    def lowest_scoring_home_team
        Team.find(
            Game.group(:home_team_id)
                .average(:home_goals, 2)
                .min_by { |k, v| v }[0]
        ).name
    end

    def winningest_coach(season_id)
        GameTeam.group(:coach)
            .where(season_id: 'WIN')
            .min_by { |k, v| v }[0]
    end

    def worst_coach(season_id)
        pass
    end

    def most_accurate_team(season_id)
        pass
    end

    def least_accurate_team(season_id)
        pass
    end

    def most_tackles(season_id)
        pass
    end
end