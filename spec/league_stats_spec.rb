require_relative './spec_helper'

describe LeagueStats do
  before(:each) do
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(locations)

    @test_games = @stat_tracker.games[0..9]
  end

  it 'exists' do
    expect(@stat_tracker.league_rspec_test).to be true
  end

  it 'can get a count of all teams' do
    expect(@stat_tracker.count_of_teams).to be_a Integer
    expect(@stat_tracker.count_of_teams).to eq(32)
  end

  it 'can get the best_offense across seasons' do
    @test_game_teams_larger = @stat_tracker.game_teams[0..50]

    expect(@stat_tracker.best_offense).to eq("Reign FC")
  end

  it 'can get the worst offense across seasons' do
    @test_game_teams_larger = @stat_tracker.game_teams[0..50]

    expect(@stat_tracker.worst_offense).to eq("Utah Royals FC")
  end

  it 'can get highest scoring visitor' do
    @stat_tracker.games = @test_games

    expect(@stat_tracker.highest_scoring_visitor).to eq("FC Dallas")
  end

  it 'can get a highest scoring home team' do
    @stat_tracker.games = @test_games

    expect(@stat_tracker.highest_scoring_home_team).to eq("FC Dallas")
  end

  it 'can get lowest scoring visitor' do
    @stat_tracker.games = @test_games

    expect(@stat_tracker.lowest_scoring_visitor).to eq("Sporting Kansas City")
  end

  it 'can get a lowest scoring home team' do
    @stat_tracker.games = @test_games

    expect(@stat_tracker.lowest_scoring_home_team).to eq("Sporting Kansas City")
  end
end