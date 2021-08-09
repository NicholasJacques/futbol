class Seasons < DataCollection
  def self.from_active_data(active_data)
    collection = Seasons.new
    seasons = active_data.games.uniq {|g| g.season_id}.map do |game|
      game.season_id
    end

    seasons.each do |season|
      collection << collection.data_type.new(season, active_data)
    end
    collection
  end

  def data_type
    Season
  end
end

class Season
  attr_reader :season, :id

  def initialize(season, active_data)
    @id = season
    @active_data = active_data
  end

  def game_teams
    @active_data.game_teams.find_all {|gt| gt.season_id == self.id}
  end

  def coaches_records
    @coaches_records ||= Hash.new { |hash, key| hash[key] = { total_games: 0, total_wins: 0 } }

    if @coaches_records.empty?
      game_teams.reduce(@coaches_records) do |coaches, game_team|
        coaches[game_team.head_coach][:total_games] += 1
        if game_team.win?
          coaches[game_team.head_coach][:total_wins] += 1
        end
        coaches_records
      end
    end
    @coaches_records
  end

  def winningest_coach
    coaches_records.max_by {|k, v| (v[:total_wins] / v[:total_games].to_f).round(2) }[0]
  end

  def worst_coach
    coaches_records.min_by {|k, v| (v[:total_wins] / v[:total_games].to_f).round(2) }[0]
  end

  def team_stats
    @team_stats ||= Hash.new { |hash, key| hash[key] = { total_shots: 0, total_goals: 0, total_games: 0, total_wins: 0 } }
  end

  def team_shots_and_goals
    @team_shots_and_goals ||= Hash.new { |hash, key| hash[key] = { total_shots: 0, total_goals: 0 } }

    if @team_shots_and_goals.empty?
      game_teams.reduce(@team_shots_and_goals) do |shots_and_goals, game_team|
        shots_and_goals[game_team.team_id][:total_shots] += game_team.shots
        shots_and_goals[game_team.team_id][:total_goals] += game_team.goals
        shots_and_goals
      end
    end
    @team_shots_and_goals
  end

  def most_accurate_team
    team_id = team_shots_and_goals.max_by {|k, v| (v[:total_goals] / v[:total_shots].to_f).round(5) }[0]
    @active_data.teams.get(team_id).name
  end

  def least_accurate_team
    team_id = team_shots_and_goals.min_by {|k, v| (v[:total_goals] / v[:total_shots].to_f).round(5) }[0]
    @active_data.teams.get(team_id).name
  end

  def most_tackles
  end
end