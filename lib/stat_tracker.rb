require 'csv'

class StatTracker

    def self.from_csv(file_locations)
        return StatTracker.new(file_locations)
    end

    def initialize(file_locations)
        @file_locations = file_locations
        @games_path = @file_locations[:games]
        @teams_path = @file_locations[:teams]
    end

    # Game Statistics

    def highest_total_score
        highest_score = nil
        CSV.foreach(@games_path, headers: true, header_converters: :symbol, converters: [:numeric]) do |row|
            total_score = row[:home_goals] + row[:away_goals]
            if highest_score.nil?
                highest_score = total_score
            elsif total_score > highest_score
                highest_score = total_score
            end
        end
        return highest_score
    end

    def lowest_total_score
        lowest_score = nil
        CSV.foreach(@games_path, headers: true, header_converters: :symbol, converters: [:numeric]) do |row|
            total_score = row[:home_goals] + row[:away_goals]
            if lowest_score.nil?
                lowest_score = total_score
            elsif total_score < lowest_score
                lowest_score = total_score
            end
        end
        return lowest_score
    end

    def percentage_home_wins
        home_wins = 0
        total_games = 0
        CSV.foreach(@games_path, headers: true, header_converters: :symbol, converters: [:numeric]) do |row|
            total_games += 1
            if row[:home_goals] > row[:away_goals]
                home_wins += 1
            end
        end
        return (home_wins / total_games.to_f).round(2)
    end

    def percentage_visitor_wins
        away_wins = 0
        total_games = 0
        CSV.foreach(@games_path, headers: true, header_converters: :symbol, converters: [:numeric]) do |row|
            total_games += 1
            if row[:away_goals] > row[:home_goals]
                away_wins += 1
            end
        end
        return (away_wins / total_games.to_f).round(2)
    end

    def percentage_ties
        ties = 0
        total_games = 0
        CSV.foreach(@games_path, headers: true, header_converters: :symbol, converters: [:numeric]) do |row|
            total_games += 1
            if row[:away_goals] == row[:home_goals]
                ties += 1
            end
        end
        return (ties / total_games.to_f).round(2)
    end
    
    def count_of_games_by_season
        result = Hash.new(0)
        CSV.foreach(@games_path, headers: true, header_converters: :symbol, converters: [:numeric]) do |row|
            result[row[:season].to_s] += 1
        end
        return result
    end

    def average_goals_per_game
        total_goals = 0
        total_games = 0
        CSV.foreach(@games_path, headers: true, header_converters: :symbol, converters: [:numeric]) do |row|
            total_games += 1
            total_goals += (row[:home_goals] + row[:away_goals])
        end
        return (total_goals / total_games.to_f).round(2)
    end

    def average_goals_by_season
        seasons = Hash.new { |hash, key| hash[key] = { total_games: 0, total_goals: 0 } }
        CSV.foreach(@games_path, headers: true, header_converters: :symbol, converters: [:numeric]) do |row|
            seasons[row[:season].to_s][:total_games] += 1
            seasons[row[:season].to_s][:total_goals] += (row[:home_goals] + row[:away_goals])
        end
        return seasons.transform_values {|v| (v[:total_goals] / v[:total_games].to_f).round(2) }
    end


    # League Statistics

    def count_of_teams
        return CSV.read(@teams_path, headers: true).length
    end

    def best_offense

    end
end