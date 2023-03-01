class Team
  attr_reader :team_id, :franchise_id, :team_name, :abbreviation, :stadium

  def initialize(data_hash)
    @team_id = data_hash[:team_id]
    @franchise_id = data_hash[:franchise_id]
    @team_name = data_hash[:team_name]
    @abbreviation = data_hash[:abbreviation]
    @stadium = data_hash[:stadium]
  end
end