class Game 

    #visitor team and home team are going to be actual instances of the team class

    attr_accessor :game_id, :season, :date, :date_year_first, :home_team, :visitor_team, :home_team_score, :visitor_team_score, :winning_team
    @@all = []

    def initialize(hash)
        @game_id = hash["game_id"]  
        @season = hash["season"]
        @date = hash["date"]
        @home_team = hash["home_team"]
        @visitor_team = hash["visitor_team"]
        @home_team_score = hash["home_team_score"]
        @visitor_team_score = hash["visitor_team_score"]
        @winning_team = hash["winning_team"]
        @date_year_first = hash["date_year_first"]

        save
    end

    def self.all
        @@all
    end

    def save
        @@all << self
    end

    def winner

    end

    



end