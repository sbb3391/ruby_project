require 'pry'

class Cli 

    attr_accessor :user, :counter, :index, :team_selection, :team_full_name, :team_nick_name, :year, :input3, :input4
    
    
    def space
        puts ""
    end
    
    def start
        system("clear")
        puts ""
        puts "Welcome to your NBA resource. Where you can get game results for your favorite NBA team!"
        sleep(1.5)
        Api.new.get_teams
        space
        menu
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
            display_record
        when "2"
            display_game_results
        else 
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
        
        space
        if @team_selection.to_i <= Team.all.size && @team_selection.to_i != 0
            @team_nick_name = Team.all[index].full_name.split(" ").last
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

    def display_record
        space
        year = @year
        input = @team_selection
        index = @index
        @team_full_name = Team.all[index].full_name
        team_record(year, input)
        sleep(3)
        space
        space
        puts "type 'y' if you would like to get #{team_full_name} game results for the #{year}-#{year.to_i + 1} season. Otherwise press enter."
        space
        x = gets.strip.downcase

        if x == "y"
            display_game_results
        else
            what_next
        end
    end

    def display_game_results
        space
        year = @year
        input = @team_selection
        index = @index
        @team_full_name = Team.all[index].full_name
        puts "Please wait while we get this data..."
        space
        game_results(year, input)
        space
        sleep(1)
        puts "type 'y' if you would like to see the record for the #{team_full_name} for the #{year}-#{year.to_i + 1} season. Otherwise press enter."
        space
        x = gets.strip.downcase

        if x == "y"
            display_record
        else
            what_next
        end
    end

    def game_results(year, input)
        #call API to get game results, populate Game.all with the results
        Api.new.get_games(year, input)

        #Look through array of all games (Game.all), get results for only the season being referenced
        games_in_season = Game.all.select {|i| i.season == @year}
        games_in_season_sorted = games_in_season.sort_by! {|i| i.date_year_first}
        
    
        #determine if the team did not exist during the given year
        if Game.all == []
            puts "The #{@team_full_name} did not play any games in the #{year} season."
        end
    
        counter = 0
        games_in_season_sorted.each do |i|
            counter += 1
            if i.home_team.full_name == @team_full_name && i.home_team_score > i.visitor_team_score
                puts "#{i.date} -- #{i.visitor_team.full_name}: #{@team_nick_name} win #{i.home_team_score} to #{i.visitor_team_score}.".green
                sleep(0.2)
            elsif i.home_team.full_name == @team_full_name && i.home_team_score < i.visitor_team_score
                puts "#{i.date} -- #{i.visitor_team.full_name}: #{@team_nick_name} lose #{i.visitor_team_score} to #{i.home_team_score}.".colorize(:red)
                sleep(0.2)
            elsif i.visitor_team.full_name == @team_full_name && i.home_team_score > i.visitor_team_score
                puts "#{i.date} -- at #{i.home_team.full_name}: #{@team_nick_name} lose #{i.home_team_score} to #{i.visitor_team_score}.".colorize(:red)
                sleep(0.2)
            elsif i.visitor_team.full_name == @team_full_name && i.home_team_score < i.visitor_team_score
                puts "#{i.date} -- at #{i.home_team.full_name}: #{@team_nick_name} win #{i.visitor_team_score} to #{i.home_team_score}.".colorize(:green)
                sleep(0.2)
            end
            
            if counter % 20 == 0
                puts "Type 'n' if you do not want to see more games. Otherwise press 'Enter'"
                input = gets.chomp 
    
                if input == "n"
                break
                end
    
            end
    
        end
    end

    def team_record(year, input)
        #call API to get game results, populate Game.all with the results
        Api.new.get_games(year, input)

        #Look through array of all games (Game.all), get results for only the season being referenced
        games_in_season = Game.all.select {|i| i.season == @year}


        wins = 0
        losses = 0

        if Game.all == []
           puts "The #{@chosen_team_full_name} did not play any games in the #{@year}-#{@year.to_i + 1} season."
           what_next
        end
  
        games_in_season.each do |i|
            
            if i.winning_team == @team_full_name
                wins += 1
            else
                losses += 1
            end
        end
     
        puts "In #{@year} the #{@chosen_team_nickname} had a record of #{wins} wins and #{losses} losses."
    end

end
    






