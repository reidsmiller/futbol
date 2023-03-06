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
    worse_times = seasons_win_percentages.min_by{|_, value| value}
    worse_times[0]
  end

  def favorite_opponent(input_team_id)
    select_team_games = @game_teams.select {|game_team| game_team.team_id == input_team_id}
    select_opponent_games = []
    select_team_games.each do |team_game|
      select_opponent_games << @game_teams.select {|game_team| game_team.game_id == team_game.game_id && game_team.team_id != team_game.team_id}
    end
    opponent_game_grouped = select_opponent_games.flatten.group_by(&:team_name)
    opponent_game_percent_win = {}
    opponent_game_grouped.each do |team_name, values|
      opponent_game_percent_win[team_name] = percent_win_loss(values)
    end
    opponent_most_won_against = opponent_game_percent_win.min_by{|_, value| value}.first
  end

  def rival(input_team_id)
    select_team_games = @game_teams.select {|game_team| game_team.team_id == input_team_id}
    select_opponent_games = []
    select_team_games.each do |team_game|
      select_opponent_games << @game_teams.select {|game_team| game_team.game_id == team_game.game_id && game_team.team_id != team_game.team_id}
    end
    opponent_game_grouped = select_opponent_games.flatten.group_by(&:team_name)
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
end