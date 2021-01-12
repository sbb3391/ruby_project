class Team

    attr_accessor :full_name, :division, :conference, :games

    @@all = []

    def self.all
        @@all
    end

    def save
        @@all << self
    end

    def self.find_by_name(name)
        self.all.detect {|team| team.full_name.downcase == name.downcase}
    end

end