class Game 

    attr_accessor :date, :home_team, :visitor_team, :home_team_score, :visitor_team_score
    @@all = []

    def self.all
        @@all
    end

    def save
        @@all << self
    end

end