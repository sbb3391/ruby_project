class Game 

    #visitor team and home team are going to be actual instances of the team class

    attr_accessor :date, :home_team, :visitor_team, :home_team_score, :visitor_team_score, :winner
    @@all = []

    def initialize(hash)

    def self.all
        @@all
    end

    def save
        @@all << self
    end

    def winner

    end

    



end