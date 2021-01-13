class Api

   attr_accessor :chosen_team_input, :chosen_team_full_name, :chosen_team_nickname

   def initialize(input = nil, team_full_name = nil)
      @chosen_team_input = input
      @chosen_team_full_name = team_full_name
   end
 
   #call API to gather a list of all NBA teams
   def get_teams
      response = HTTParty.get('https://www.balldontlie.io/api/v1/teams')["data"]
      response.each do |i|
         team = Team.new
         
         team.full_name = i["full_name"]
         team.division = i["division"]
         team.conference = i["conference"]

         team.save

      end   
   end

   #Make API call to create a hash of all games played by one team in one year (both year and team chosen by the user)
   #returns the hash
   def get_games(year, input)
      page = 1
      query = 'https://www.balldontlie.io/api/v1/games' + '?seasons[]=' + year.to_s + '&team_ids[]=' + input.to_s + '&page=' + page.to_s
      response_meta = HTTParty.get(query)["meta"]
      response_data = HTTParty.get(query)["data"]
      total_pages = response_meta["total_pages"]
      games_hash = {}

      while page <= total_pages

         #Go back and maximize the per_page limit to minimize the number of calls
         query = 'https://www.balldontlie.io/api/v1/games' + '?seasons[]=' + year.to_s + '&team_ids[]=' + input.to_s + '&page=' + page.to_s + '&per_page=50'
         HTTParty.get(query)["data"].each do |i|
            id = i["id"]
            if Game.all.none? {|i| i.game_id == id}
            
               #change formatting of date
               date = i["date"].split("-")
               day_value = date[2].split(/T/)[0]
               key_date = "#{date[0]}/#{date[1]}/#{day_value}"
               formatted_date = "#{date[1]}/#{day_value}/#{date[0]}"
               
               #determine winning team
               if i["home_team_score"] > i["visitor_team_score"]
                  winner = i["home_team"]["full_name"]
               else
                  winner = i["visitor_team"]["full_name"]
               end

               
               
               #make visitor and home team reference existing team objects
               games_hash[key_date] = {
                  "game_id" => i["id"],
                  "season" => year,
                  "date" => formatted_date,
                  "home_team" => Team.find_by_name(i["home_team"]["full_name"]),
                  "visitor_team" => Team.find_by_name(i["visitor_team"]["full_name"]),
                  "home_team_score" => i["home_team_score"],
                  "visitor_team_score" => i["visitor_team_score"],
                  "winning_team" => winner,
                  "date_year_first" => key_date
               }
               
               
               Game.new(games_hash[key_date].sort.to_h)
            end

         end
         page += 1 
      end
      games_hash
   end

end


