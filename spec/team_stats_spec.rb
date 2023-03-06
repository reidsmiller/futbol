require_relative './spec_helper'

RSpec.describe TeamStats do
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
    @test_games_larger = @stat_tracker.games[0..100]
    @test_game_teams = @stat_tracker.game_teams[0..9]
  end

  it 'can create team hash' do
    expect(@stat_tracker.team_info("1")["team_id"]).to eq("1")
    expect(@stat_tracker.team_info("1")["franchise_id"]).to eq("23")
    expect(@stat_tracker.team_info("1")["team_name"]).to eq("Atlanta United")
    expect(@stat_tracker.team_info("1")["abbreviation"]).to eq("ATL")
    expect(@stat_tracker.team_info("1")["link"]).to eq("/api/v1/teams/1")
  end

  it "#best_season" do
    expect(@stat_tracker.best_season("6")).to eq "20132014"
  end

  it "#worst_season" do
    expect(@stat_tracker.worst_season("6")).to eq "20142015"
  end

  it "#average_win_percentage" do
    expect(@stat_tracker.average_win_percentage("6")).to eq 0.49
  end

  it "#most_goals_scored" do
    expect(@stat_tracker.most_goals_scored("18")).to eq 7
  end

  it "#fewest_goals_scored" do
    expect(@stat_tracker.fewest_goals_scored("18")).to eq 0
  end

  it "#favorite_opponent" do
    expect(@stat_tracker.favorite_opponent("18")).to eq "DC United"
  end

  it "#rival" do
    expect(@stat_tracker.rival("18")).to eq("Houston Dash").or(eq("LA Galaxy"))
  end

  it '#biggest_team_blowout' do
    expect(@stat_tracker.biggest_team_blowout("18")).to eq(5)
  end

  it '#worst_loss' do
    expect(@stat_tracker.worst_loss("18")).to eq(4)
  end

  it '#head_to_head' do
    expect(@stat_tracker.head_to_head("18")).to be_a Hash
    expect(@stat_tracker.head_to_head("18")['Atlanta United']).to eq(0.5)
    expect(@stat_tracker.head_to_head("18")['Chicago Fire']).to eq(0.3)
  end
  
  it '#seasonal_summary' do
    # expect(@stat_tracker.seasonal_summary("18")["20172018"]["Postseason"][:win_percentage]).to eq(0.54)
    # expect(@stat_tracker.seasonal_summary("18")["20162011"]["Postseason"][:total_goals_scored]).to eq(48)
    # expect(@stat_tracker.seasonal_summary("16")["20122013"]["Regular Season"][:total_goals_against]).to eq(85)
    # expect(@stat_tracker.seasonal_summary("16")["20122013"]["Regular Season"][:average_goals_scored]).to eq(2.44)
    # expect(@stat_tracker.seasonal_summary("16")["20132014"]["Regular Season"][:average_goals_against]).to eq(2.12)
    expect(@stat_tracker.seasonal_summary("18")).to eq({"20162017"=>
      {"Postseason"=>{:win_percentage=>0.59, :total_goals_scored=>48, :total_goals_against=>40, :average_goals_scored=>2.18, :average_goals_against=>1.82},
       "Regular Season"=>{:win_percentage=>0.38, :total_goals_scored=>180, :total_goals_against=>170, :average_goals_scored=>2.2, :average_goals_against=>2.07}},
     "20172018"=>
      {"Postseason"=>{:win_percentage=>0.54, :total_goals_scored=>29, :total_goals_against=>28, :average_goals_scored=>2.23, :average_goals_against=>2.15},
       "Regular Season"=>{:win_percentage=>0.44, :total_goals_scored=>187, :total_goals_against=>162, :average_goals_scored=>2.28, :average_goals_against=>1.98}},
     "20132014"=>
     {"Regular Season"=>{:win_percentage=>0.38, :total_goals_scored=>166, :total_goals_against=>177, :average_goals_scored=>2.02, :average_goals_against=>2.16}},
     "20122013"=>{"Regular Season"=>{:win_percentage=>0.25, :total_goals_scored=>85, :total_goals_against=>103, :average_goals_scored=>1.77, :average_goals_against=>2.15}},
     "20142015"=>
     {"Regular Season"=>{:win_percentage=>0.5, :total_goals_scored=>186, :total_goals_against=>162, :average_goals_scored=>2.27, :average_goals_against=>1.98},
     "Postseason"=>{:win_percentage=>0.67, :total_goals_scored=>17, :total_goals_against=>13, :average_goals_scored=>2.83, :average_goals_against=>2.17}},
     "20152016"=>
     {"Regular Season"=>{:win_percentage=>0.45, :total_goals_scored=>178, :total_goals_against=>159, :average_goals_scored=>2.17, :average_goals_against=>1.94},
     "Postseason"=>{:win_percentage=>0.36, :total_goals_scored=>25, :total_goals_against=>33, :average_goals_scored=>1.79, :average_goals_against=>2.36}}})
  end
end