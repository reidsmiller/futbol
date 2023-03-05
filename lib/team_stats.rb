require_relative './helper'

module TeamStats
  include Helper

  def team_info(input_team_id)
    selected_team = @teams.select {|team| team.team_id == input_team_id}[0]
    team_info = {
      "team_id" => selected_team.team_id,
      "franchise_id" => selected_team.franchise_id,
      "team_name" => selected_team.team_name,
      "abbreviation" => selected_team.abbreviation,
      "link" => selected_team.link
    }
  end

  def best_season(input_team_id)
    team_group = @game_teams.select {|game_team| game_team.team_id == input_team_id}
    team_seasons = team_group.group_by(&:season)
    team_season_percent = {}
    team_seasons.each do |season, values|
      team_season_percent[season] = percent_win_loss(values)
    end
    bestest_season = team_season_percent.max_by {|_, value| value}[0]
  end

  def worst_season(input_team_id)
    team_group = @game_teams.select {|game_team| game_team.team_id == input_team_id}
    team_seasons = team_group.group_by(&:season)
    team_season_percent = {}
    team_seasons.each do |season, values|
      team_season_percent[season] = percent_win_loss(values)
    end
    bestest_season = team_season_percent.min_by {|_, value| value}[0]
  end

  def average_win_percentage(input_team_id)
    team_group = game_teams.select {|game_team| game_team.team_id == input_team_id}
    percent_win_loss(team_group).round(2)
  end
end