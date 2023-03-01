require_relative './helper'

module GameStats
  include Helper

  def game_rspec_test
    true
  end

  def highest_total_score
    highest_game = @games.max_by do |game|
      game.away_goals + game.home_goals
    end
    highest_game.away_goals + highest_game.home_goals
  end

  def lowest_total_score
    lowest_game = @games.min_by do |game|
      game.away_goals + game.home_goals
    end
    lowest_game.away_goals + lowest_game.home_goals
  end

  def percentage_home_wins

  end

  def percentage_visitor_wins

  end

  def percentage_ties

  end

  def count_of_games_by_season

  end

  def average_goals_per_game
    number_of_games = total_games(@games)
    number_of_goals = @games.sum {|game| total_goals(game)}

    number_of_goals.fdiv(number_of_games)
  end

  def average_goals_per_season
    result = Hash.new(0)
    games_by_season = @games.group_by{|game| game.season}
    games_by_season.each do |season, games|
      result[season] += (games.sum{|game| total_goals(game)}).fdiv(total_games(games))
    end
    result
  end
end