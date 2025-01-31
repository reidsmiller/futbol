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
    seasons_win_percentages = Hash.new(0)
    team_games = @game_teams.select {|game_team| game_team.team_id == input_team_id}
    seasonal_games = team_games.group_by(&:season)
    seasonal_games.map do |season, games|  
      seasons_win_percentages[season] = percent_win_loss(games)
    end
    good_times = seasons_win_percentages.max_by{|_, value| value}
    good_times[0]
  end

  def worst_season(input_team_id)
    seasons_win_percentages = Hash.new(0)
    team_games = @game_teams.select {|game_team| game_team.team_id == input_team_id}
    seasonal_games = team_games.group_by(&:season)
    seasonal_games.map do |season, games|  
      seasons_win_percentages[season] = percent_win_loss(games)
    end
    bad_times = seasons_win_percentages.min_by{|_, value| value}
    bad_times[0]
  end

  def average_win_percentage(input_team_id)
    team_group = game_teams.select {|game_team| game_team.team_id == input_team_id}
    percent_win_loss(team_group).round(2)
  end

  def most_goals_scored(input_team_id)
    team_group = game_teams.select {|game_team| game_team.team_id == input_team_id}
    highest_score = team_group.max_by(&:goals).goals
  end

  def fewest_goals_scored(input_team_id)
    team_group = game_teams.select {|game_team| game_team.team_id == input_team_id}
    fewest_score = team_group.min_by(&:goals).goals
  end

  def favorite_opponent(input_team_id)
    opponent_game_grouped = get_all_opponent_games(input_team_id).flatten.group_by(&:team_name)
    opponent_game_percent_win = {}
    opponent_game_grouped.each do |team_name, values| 
      opponent_game_percent_win[team_name] = percent_win_loss(values)
    end
    opponent_most_won_against = opponent_game_percent_win.min_by{|_, value| value}.first
  end

  def rival(input_team_id)
    opponent_game_grouped = get_all_opponent_games(input_team_id).flatten.group_by(&:team_name)
    opponent_game_percent_win = {}
    opponent_game_grouped.each do |team_name, values| 
      opponent_game_percent_win[team_name] = percent_win_loss(values)
    end
    opponent_most_won_against = opponent_game_percent_win.max_by{|_, value| value}.first
  end

  def biggest_team_blowout(input_team_id)
    wins = get_wins(input_team_id)
    wins.map do |game|
      if game.away_team_id == input_team_id
        game.away_goals - game.home_goals
      elsif game.home_team_id == input_team_id
        game.home_goals - game.away_goals
      end
    end.max
  end

  def worst_loss(input_team_id)
    losses = get_losses(input_team_id)
    losses.map do |game|
      if game.away_team_id == input_team_id
        game.home_goals - game.away_goals
      elsif game.home_team_id == input_team_id
        game.away_goals - game.home_goals
      end
    end.max
  end

  def head_to_head(input_team_id)
    games_by_opponent = get_all_opponent_games(input_team_id).flatten.group_by(&:team_name)
    record = {}
    games_by_opponent.each do |team_name, values|
      record[team_name] = percent_win_for_input_team(values).round(2)
    end
    record
  end

  def seasonal_summary(input_team_id)
    team_group = @games.select {|game| game.away_team_id == input_team_id || game.home_team_id == input_team_id}
    team_seasons = team_group.group_by(&:season)
    team_games = {}
    team_seasons.each do |season, values|
      team_games[season] = values.group_by(&:type)
    end
    team_games.each do |_, values|
      values.each do |type, data|
        values[type] = {
          win_percentage: summary_win_percent(input_team_id, data),
          total_goals_scored: summary_total_goals_scored(input_team_id, data),
          total_goals_against: summary_total_goals_against(input_team_id, data),
          average_goals_scored: summary_ave_goals_scored(input_team_id, data),
          average_goals_against: summary_ave_goals_against(input_team_id, data)
        }
      end
    end
    team_games
  end
end