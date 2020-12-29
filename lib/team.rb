class Team

    attr_accessor :full_name, :division, :conference

    @@all = []

    def self.all
        @@all
    end

    def save
        @@all << self
    end


end