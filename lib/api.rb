class Api
 
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

   #Use list of NBA teams from API call to create terminal output that shows the user the team they selected
   def team_information
      index = input - 1
      url = 'https://www.balldontlie.io/api/v1/teams'
      response = self.call_api(url)["data"][index]

      puts "You've selected the #{response["full_name"]}, from the #{response["division"]} Division of the #{response["conference"]}ern Conference."
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

         query = 'https://www.balldontlie.io/api/v1/games' + '?seasons[]=' + year.to_s + '&team_ids[]=' + input.to_s + '&page=' + page.to_s
         HTTParty.get(query)["data"].each do |i|

            # game = Game.new

            #change formatting of date
            date = i["date"].split("-")
            day_value = date[2].split(/T/).shift
            key_date = "#{date[0]}/#{date[1]}/#{day_value}"
            formatted_date = "#{date[1]}/#{day_value}/#{date[0]}"

          

            games_hash[key_date] = {
               "date" => formatted_date,
               "home_team" => i["home_team"]["full_name"],
               "visitor_team" => i["visitor_team"]["full_name"],
               "home_team_score" => i["home_team_score"],
               "visitor_team_score" => i["visitor_team_score"]
            }
            # game.date = formatted_date
            # game.home_team = i["home_team"]["full_name"]
            # game.visitor_team = i["visitor_team"]["full_name"]
            # game.home_team_score = i["home_team_score"]
            # game.visitor_team_score = i["visitor_team_score"]

            # game.save

         end
         page += 1 
      end
      games_hash
   end

   #Use get_games method to create terminal output showing the results of every game played by one team during one season
   def game_info(year, input)
      x = get_games(year, input).sort.to_h
      x.each do |key, value|
         if value["home_team_score"] > value["visitor_team_score"]
            puts "On #{value["date"]} the #{value["home_team"]} defeated the visiting #{value["visitor_team"]} by a score of #{value["home_team_score"]} to #{value["visitor_team_score"]}."
         else
            puts "On #{value["date"]} the #{value["home_team"]} was defeated by the visiting #{value["visitor_team"]} by a score of #{value["home_team_score"]} to #{value["visitor_team_score"]}."
         end
      end
   end

end

