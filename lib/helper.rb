module Helper
  def total_goals(game)
    game.away_goals + game.home_goals
  end

  def total_games(games)
    games.count
  end

  def total_teams(teams)
    teams.count
  end

  def average_away_goals(input_games)
    sum_away_goals = input_games.sum(&:away_goals)
    sum_away_goals.fdiv(input_games.count)
  end

  def average_home_goals(input_games)
    sum_home_goals = input_games.sum(&:home_goals)
    sum_home_goals.fdiv(input_games.count)
  end

  def average_of_goals(input_games)
    sum_goals = input_games.sum(&:goals)
    sum_goals.fdiv(input_games.count)
  end

  def average_accuracy(input_games)
    sum_shots = input_games.sum(&:shots)
    sum_goals = input_games.sum(&:goals)
    (sum_goals.fdiv(sum_shots)*100).round(2)
  end

  def percent_win_loss(input_games)
    count_wins = input_games.count {|game_team| game_team.result == "WIN"}
    count_wins.fdiv(input_games.length)
  end

  def get_wins(id)
    @games.select {|game| away_win?(game, id) || home_win?(game, id)}
  end

  def get_losses(id)
    @games.select{|game| away_loss?(game, id) || home_loss?(game, id)}
  end

  def away_win?(game, id)
    game.away_team_id == id && game.away_goals > game.home_goals
  end

  def home_win?(game, id)
    game.home_team_id == id && game.home_goals > game.away_goals
  end

  def away_loss?(game, id)
    game.away_team_id == id && game.away_goals < game.home_goals
  end

  def home_loss?(game, id)
    game.home_team_id == id && game.home_goals < game.away_goals
  end

  def summary_win_percent(input_team_id, data)
    wins = data.select {|game| away_win?(game, input_team_id) || home_win?(game, input_team_id)}.count
    wins.fdiv(data.length).round(2)
  end

  def summary_total_goals_scored(input_team_id, data)
    count = 0
    data.each do |game|
      if game.away_team_id == input_team_id
        count += game.away_goals
      elsif game.home_team_id == input_team_id
        count += game.home_goals
      end
    end
    count
  end

  def summary_total_goals_against(input_team_id, data)
    count = 0
    data.each do |game|
      if game.away_team_id == input_team_id
        count += game.home_goals
      elsif game.home_team_id == input_team_id
        count += game.away_goals
      end
    end
    count
  end

  def summary_ave_goals_scored(input_team_id, data)
    scores = []
    data.each do |game|
      if game.away_team_id == input_team_id
        scores << game.away_goals
      elsif game.home_team_id == input_team_id
        scores << game.home_goals
      end
    end
    scores.sum.fdiv(scores.length).round(2)
  end

  def summary_ave_goals_against(input_team_id, data)
    scores = []
    data.each do |game|
      if game.away_team_id == input_team_id
        scores << game.home_goals
      elsif game.home_team_id == input_team_id
        scores << game.away_goals
      end
    end
    scores.sum.fdiv(scores.length).round(2)
  end
end