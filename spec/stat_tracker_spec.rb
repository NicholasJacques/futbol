require 'spec_helper'

RSpec.describe StatTracker do
  game_path = './data/games.csv'
  team_path = './data/teams.csv'
  game_teams_path = './data/game_teams.csv'
  
  locations = {
    games: game_path,
    teams: team_path,
    game_teams: game_teams_path
  }

  describe 'class methods' do
    describe '.from_csv' do
      stat_tracker = StatTracker.from_csv(locations)

      it 'returns an instance of StatTracker' do
        expect(stat_tracker).to be_a(StatTracker)
      end
    end
  end

  describe 'instance methods' do
    stat_tracker = StatTracker.from_csv(locations)
    describe '#highest_total_score' do
      it "Returns the highest sum of the winning and losing team's scores" do
        expect(stat_tracker.highest_total_score).to eq(11)
      end
    end
    describe '#lowest_total_score' do
      it "Returns the lowest sum of the winning and losing team's scores" do
        expect(stat_tracker.lowest_total_score).to eq(0)
      end
    end
    describe '#percentage_home_wins' do
      it "Returns the percentage of games won by the home team" do
        expect(stat_tracker.percentage_home_wins).to eq(0.44)
      end
    end
    describe '#percentage_visitor_wins' do
      it "Returns the percentage of games won by the away team" do
        expect(stat_tracker.percentage_visitor_wins).to eq(0.36)
      end
    end
    describe '#percentage_ties' do
      it "Returns the percentage of games won by the away team" do
        expect(stat_tracker.percentage_ties).to eq(0.2)
      end
    end
    describe '#count_of_games_by_season' do
      it "Returns a hash where the key is the season and value is count of games in that season" do
        expect(stat_tracker.count_of_games_by_season).to eq(
          {
            "20122013" => 806,
            "20132014" => 1323,
            "20142015" => 1319,
            "20152016" => 1321,
            "20162017" => 1317,
            "20172018" => 1355,
          }
        )
      end
    end
    describe '#average_goals_per_game' do
      it "Returns the average number of total goals scored per game across all seasons" do
        expect(stat_tracker.average_goals_per_game).to eq(4.22)
      end
    end

    describe '#average_goals_by_season' do
      it "Returns a hash where the key is the season and value is average total goals per game in that season" do
        expect(stat_tracker.average_goals_by_season).to eq(
          {
            "20122013" => 4.12,
            "20132014" => 4.19,
            "20142015" => 4.14,
            "20152016" => 4.16,
            "20162017" => 4.23,
            "20172018" => 4.44,
          }
        )
      end
    end

    describe '#count_of_teams' do
      it "Returns the number of unique teams in the data" do
        expect(stat_tracker.count_of_teams).to eq(32)
      end
    end

    describe '#best_offense' do
      it "Name of the team with the highest average number of goals scored per game across all seasons" do
        expect(stat_tracker.best_offense).to eq('Reign FC')
      end
    end

    # describe '#winningest_coach' do
    #   it "Name of the coach  with the highest win percentage for a given season" do
    #     expect(stat_tracker.winningest_coach("20132014")).to eq('Reign FC')
    #   end
    # end

  end
end