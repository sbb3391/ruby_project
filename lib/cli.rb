require 'pry'

class Cli 

    attr_accessor :user, :counter, :index, :team_selection, :team_nick_name, :year, :input3, :input4
    
    
    
    def start
        system("clear")
        puts ""
        puts "Welcome to your NBA resource. Where you can get game results for your favorite NBA team!"
        sleep(1.5)
        Api.new.get_teams
        space
        menu
    end
    
   
    
    def space
        puts ""
    end
    
    def menu
        team_select
            
        get_year
    
    end

    def games_or_record
        puts "Would you like to:"
        puts "1) See team record for the #{self.team_nick_name} in the #{@year}-#{@year.to_i + 1} season"
        puts "2) See individual game results for #{self.team_nick_name} for the #{@year}-#{@year.to_i + 1} season"
        puts "Please select your answer..."
        space
        input = gets.strip

        case input
        when "1"
            get_record
        when "2"
            get_games
        when !"1" || !"2"
            puts "That is an incorrect response. Please try again"
            games_or_record
        end
    end

    def show_teams
        Team.all.each_with_index do |i, index|
            puts "#{index+1}) #{i.full_name}"
        end
    end

    def team_select

        puts "--------- NBA Basketball Teams ---------"
        space
        show_teams
        space
        
        puts "What team would you like to see?"
        space
        @team_selection = gets.strip
        @index = @team_selection.to_i - 1
        index = @index
        @team_nick_name = Team.all[index].full_name.split(" ").last
        
        space
        if @team_selection.to_i <= Team.all.size && @team_selection.to_i != 0
            puts "--- You've selected the #{Team.all[index].full_name}, from the #{Team.all[index].division} Division of the #{Team.all[index].conference}ern Conference. ---"
            space
        else 
            system("clear")
            puts "Invalid selection. Please select a number between 1 and #{Team.all.size}"
            sleep(3)
            space
            menu
        end
    end

    def what_next
        puts "What would you like to do next?"
        puts "1) See data for a different season"
        puts "2) Select a different team"
        puts "3) Exit"
        space

        input = gets.strip

        space

        case input 
        when "1"
            system("clear")
            get_year
        when "2"
            system("clear")
            menu
        when "3"
            puts "Thank you for using your NBA resource. Have a great day!"
        when !"1" && !"2" && !"3"
            puts "sorry please input a selection between 1 and 3"
            what_next
        end
    end

    def select_team
        puts "Select the team number..."
            space
        @team_selection = gets.strip.to_i 
            space
        #take input and use it in Api.team_information method
        Api.team_information(@team_selection)
            space

    end
            
            
    
    def game_info

        page = 1

        puts "--- What season are you interested in? ---"
            space
        @year = gets.strip
            space
        Api.game_information_by_season(@team_selection, @year)
            space
        puts "Would you like to see 10 more game results? (y/n)"
            space
        input3 = gets.strip.downcase
            case input3
            when "y"
                page += 1 
                Api.game_information_by_season(@team_selection, @year, page)
            when "n"
                puts "Thank you for using your trusted NBA resource. Have a great day!"
            end
    end

    def get_year
        puts "What season are you interested in? Please select a season between 1970 and 2019"
        space
        @year = gets.strip
        system("clear")

        if @year.to_i >= 2020 || @year.to_i < 1970
            puts "Invalid selection. Please select a season between 1970 and 2019"
            sleep(4)
            space
            get_year
        end

        games_or_record
    end

    def get_record
        space
            year = @year
            input = @team_selection
            index = @index
            team_full_name = Team.all[index].full_name
            x = Api.new(input, team_full_name)
            x.team_record(year, input)
            sleep(3)
            space
            space
            puts "type 'y' if you would like to get #{team_full_name} game results for the #{year}-#{year.to_i + 1} season. Otherwise press enter."
            space
            x = gets.strip.downcase

            if x == "y"
                get_games
            else
                what_next
            end
        end

        def get_games
            space
            year = @year
            input = @team_selection
            index = @index
            team_full_name = Team.all[index].full_name
            puts "Please wait while we get this data..."
            space
            x = Api.new(input, team_full_name)
            x.game_info(year, input)
            space
            sleep(1)
            puts "type 'y' if you would like to see the record for the #{team_full_name} for the #{year}-#{year.to_i + 1} season. Otherwise press enter."
            space
            x = gets.strip.downcase

            if x == "y"
                get_record
            else
                what_next
            end
        end
    
end
    






