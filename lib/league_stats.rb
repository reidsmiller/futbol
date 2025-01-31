require_relative './helper'

module LeagueStats
  include Helper

  def league_rspec_test
    true
  end

  def count_of_teams
    total_teams(@teams)
  end

  def best_offense
    info_by_team = @game_teams.group_by(&:team_name)
    team_goals_average = {}
    info_by_team.map do |team, games|  
      team_goals_average[team] = average_of_goals(games)
    end
    da_best_of_all = team_goals_average.max_by{|_, values| values}
    da_best_of_all[0]
  end

  def worst_offense
    info_by_team = @game_teams.group_by(&:team_name)
    team_goals_average = {}
    info_by_team.map do |team, games|  
      team_goals_average[team] = average_of_goals(games)
    end
    da_worst_of_all = team_goals_average.min_by{|_, values| values}
    da_worst_of_all[0]
  end

  def highest_scoring_visitor
    away_teams = @games.group_by(&:away_team_name)
    away_teams_ave_score = {}
    away_teams.each do |team, values|
      away_teams_ave_score[team] = average_away_goals(values)
    end
    highest_scoring = away_teams_ave_score.max_by {|_, value| value}
    highest_scoring[0]
  end

  def highest_scoring_home_team
    home_teams = @games.group_by(&:home_team_name)
    home_teams_avg = {}
    home_teams.each do |team, values|
      home_teams_avg[team] = average_home_goals(values)
    end
    highest_scoring = home_teams_avg.max_by{|_, value| value}
    highest_scoring[0]
  end

  def lowest_scoring_visitor
    away_teams = @games.group_by(&:away_team_name)
    away_teams_ave_score = {}
    away_teams.each do |team, values|
      away_teams_ave_score[team] = average_away_goals(values)
    end
    lowest_scoring = away_teams_ave_score.min_by {|_, value| value}
    lowest_scoring[0]
  end

  def lowest_scoring_home_team
    home_teams = @games.group_by(&:home_team_name)
    home_teams_avg = {}
    home_teams.each do |team, values|
      home_teams_avg[team] = average_home_goals(values)
    end
    lowest_scoring = home_teams_avg.min_by{|_, value| value}
    lowest_scoring[0]
  end
end