class Cli 

    attr_accessor :team_selection, :year, :input3, :input4

    puts ""
    puts "Hi Kellen - Welcome to your NBA resource. Where you can get game results for your favorite NBA team!" 
    
    def start
        Api.new.get_teams
        space
        menu
    end
    
    def show_teams
        Team.all.each_with_index do |i, index|
            puts "#{index+1}) #{i.full_name}"
        end
    end
    
    def space
        puts ""
    end
    
    def menu
        input = ""
        while input != "exit"
            puts "--------- NBA Basketball Teams ---------"
            space
            show_teams
            puts "What team would you like to see?"
            input = gets.strip
            index = input.to_i - 1
            space
            puts "You've selected the #{Team.all[index].full_name}, from the #{Team.all[index].division} Division of the #{Team.all[index].conference}ern Conference."
            space

            if index <= Team.all.size
                puts "What year are you interested in?"
                space
                year = gets.strip
                Api.new.game_info(year, input)
                space
                puts "type 'exit' to end this session, or any key to see another team's game data."
                space
                input = gets.strip
                
            end
        end
    end



    def initial_options

        initial_options_prompt
            space
        puts "--------- NBA Basketball Teams ---------"
            space
        Api.get_teams('https://www.balldontlie.io/api/v1/teams')
            space
        select_team
            space
        game_info
            
            
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
    
end
    






