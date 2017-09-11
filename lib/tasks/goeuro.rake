namespace :goeuro do 
  task search: :environment do 
    loop do
      STDOUT.puts "Enter search text:"
      search_city = STDIN.gets.strip
      response = HTTParty.get("https://www.goeuro.com/suggester-api/v2/position/suggest/en/#{search_city}")
      response.parsed_response.each do |city|
        City.find_or_create_by("city_id" => city["_id"],"name" => city["name"], "fullName" => city["fullName"], "country" => city["country"], "latitude" => city["geo_position"]["latitude"], "longitude" => city["geo_position"]["longitude"],"locationId" => city["locationId"], "inEurope" => city["inEurope"], "countryId" => city["countryId"], "countryCode" => city["countryCode"],"coreCountry" => city["coreCountry"],"city_type" => city["type"],"iata_airport_code" => city["iata_airport_code"])
      end
    end
  end


  task auto_search: :environment do
    country_list = ["Albania","Andorra","Armenia","Austria","Azerbaijan","Belarus","Belgium","Bosnia and Herzegovina","Bulgaria","Croatia","Cyprus","Czech Republic","Denmark","Estonia","Finland","France","Georgia","Germany","Greece","Greenland","Hungary","Iceland","Ireland","Italy","Kosovo","Latvia","Liechtenstein","Lithuania","Luxembourg","Macedonia","Malta","Moldova","Monaco","Montenegro","Netherlands","Norway","Poland","Portugal","Romania","Russia","San Marino","Serbia","Slovakia","Slovenia","Spain","Sweden","Switzerland","Turkey","Ukraine","United Kingdom"]
    country_list.each do |country|
      country_code = CS.countries.select{|key, hash| hash == country }.keys[0]
      CS.states(country_code).each do |key,value|
        CS.cities(key, country_code).each do |city|
          city = city.gsub(/\s+/, '%20')
          url = "https://www.goeuro.com/suggester-api/v2/position/suggest/en/#{city}"
          encoded_url = URI.encode(url)
          response = HTTParty.get(URI.parse(encoded_url))
          response.parsed_response.each do |city|
            City.find_or_create_by("city_id" => city["_id"],"name" => city["name"], "fullName" => city["fullName"], "country" => city["country"], "latitude" => city["geo_position"]["latitude"], "longitude" => city["geo_position"]["longitude"],"locationId" => city["locationId"], "inEurope" => city["inEurope"], "countryId" => city["countryId"], "countryCode" => city["countryCode"],"coreCountry" => city["coreCountry"],"city_type" => city["type"],"iata_airport_code" => city["iata_airport_code"])
          end
        end
      end
    end
  end

  task get_flight_details: :environment do 
    cities_name = ["London","Paris","Rome","Dublin","Madrid","Barcelona","Frankfurt","Milan","Athens","Amsterdam"]
    cities = ["LHR","CDG","FCO","DUB","MAD","BCN","FRA","MXP","ATH","AMS"]
    city_combination =  cities.permutation(2).to_a
    city_combination.each do |city|
      @count = 0
      arrival = City.find_by(:iata_airport_code => city[0]).city_id
      departure = City.find_by(:iata_airport_code => city[1]).city_id

      @cookie = '_go_client_id=CvAA8lmyI02O9XSzAw6LAg==; _fsid=sc8mhqboqj4dq9fnqc1o3hni35; discountTooltipShown=true; cookie-policy-banner=true; goeuroapi-backend=29306ba48f2fe93936bd4a09c2b08658c5477f7c; cookiePal=old; farm_identifier=EU; X-Backend-Server=search-prod-eu-2|WbN0c|WbN0c; __utmt=1; optimizelySegments=%7B%22506211048%22%3A%22search%22%2C%22506270641%22%3A%22gc%22%2C%22506290955%22%3A%22false%22%2C%225278930068%22%3A%22none%22%2C%225382050211%22%3A%22com%22%7D; optimizelyBuckets=%7B%7D; optimizelyEndUserId=oeu1504846671274r0.38365949898482987; _uetsid=_uetfe9bd9b1; __utma=172288693.701171210.1504846669.1504932961.1504933001.5; __utmb=172288693.2.10.1504933001; __utmc=172288693; __utmz=172288693.1504846669.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); _ceg.s=ow00b5; _ceg.u=ow00b5; _sp_id.a63e=5deecb03-1ee7-4b6d-a96a-fcb59dff12af.1504846670.4.1504936338.1504933032.d7c08e7b-8f46-4034-bbc2-f5911f7e6493; _sp_ses.a63e=*; rollout_GA=GA1.2.701171210.1504846669; rollout_GA_gid=GA1.2.1171569205.1504846670; sp=25ac56c5-c007-454d-b311-15c1a63d4dc7; __zlcmid=iPgjMkr39wEF2g; X-Ingress=k8s-prod-eu-1|WbODE|WbN0Y'


      @user_agent = ["Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; en-US) AppleWebKit/534.3 (KHTML, like Gecko) Chrome/6.0.464.0 Safari/534.3",
        "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.13 (KHTML, like Gecko) Chrome/9.0.597.15 Safari/534.13",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.835.186 Safari/535.1",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.874.54 Safari/535.2",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.36 Safari/535.7",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_0) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1063.0 Safari/536.3",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.4 (KHTML like Gecko) Chrome/22.0.1229.79 Safari/537.4",
        "Mozilla/5.0 (Macintosh; U; Mac OS X Mach-O; en-US; rv:2.0a) Gecko/20040614 Firefox/3.0.0 ",
        "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10.5; en-US; rv:1.9.0.3) Gecko/2008092414 Firefox/3.0.3",
        "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1) Gecko/20090624 Firefox/3.5",
        "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.14) Gecko/20110218 AlexaToolbar/alxf-2.0 Firefox/3.6.14",
        "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10.5; en-US; rv:1.9.2.15) Gecko/20110303 Firefox/3.6.15",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:5.0) Gecko/20100101 Firefox/5.0",

        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0) Gecko/20100101 Firefox/9.0",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2; rv:10.0.1) Gecko/20100101 Firefox/10.0.1",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20120813 Firefox/16.0",
        "Mozilla/4.0 (compatible; MSIE 5.15; Mac_PowerPC)",
        "Opera/9.0 (Macintosh; PPC Mac OS X; U; en)",
        "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/125.2 (KHTML, like Gecko) Safari/85.8",
        "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/125.2 (KHTML, like Gecko) Safari/125.8",
        "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; fr-fr) AppleWebKit/312.5 (KHTML, like Gecko) Safari/312.3",
        "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/418.8 (KHTML, like Gecko) Safari/419.3"]

        @uAgent = @user_agent.sample
        @search_id = HTTParty.post("https://www.goeuro.com/GoEuroAPI/rest/api/v5/searches",
        { 
          :body => {"searchOptions" => {"departurePosition" => {"id" => arrival},"arrivalPosition" => {"id" => departure},"travelModes" => ["Flight","Train","Bus"],"departureDate" => "2017-09-09","passengers" => [{"age" => 12,"discountCards" => []}],"userInfo" => {"identifier" => "0.hkfmyj74wa9","domain" => ".com","locale" => "en","currency" => "EUR"},"abTestParameters" => ["","APIV5_TRIGGER"]}}.to_json,
          :headers => { 'Content-Type' => 'application/json', 'Cookie' => @cookie, 'User-Agent' => @uAgent }
          }).parsed_response["searchId"]

        puts @search_id
        sleep(2.0)
        response = get_response("flight")
        name = response["positions"][response["query"]["departurePosition"]]["name"] + " - " + response["positions"][response["query"]["arrivalPosition"]]["name"]
        puts name
        source = response["positions"][response["query"]["departurePosition"]]["name"]
        destination = response["positions"][response["query"]["arrivalPosition"]]["name"]
        source_iata_code = response["positions"][response["query"]["departurePosition"]]["iataCode"]
        destination_iata_code = response["positions"][response["query"]["arrivalPosition"]]["iataCode"]

        dump = []
        puts response["outbounds"].count
        response["outbounds"].each do |key,value|
          flight_detail = {"routes" => []}
          flight_detail["flight"] = response["companies"][value["companyId"]]["name"]
          flight_detail["duration"] = value["duration"]
          flight_detail["departureTime"] = value["departureTime"]
          flight_detail["arrivalTime"] = value["arrivalTime"]
          flight_detail["stops"] = value["stops"]
          flight_detail["price"] = value["price"]
          if value["segments"].count > 1
            value["segments"].each do |segment|
              route = {}
              route["name"] = response["positionReport"][response["segmentDetails"]["#{segment}"]["arrivalPosition"]]["name"]
              route["iata_code"] = response["positionReport"][response["segmentDetails"]["#{segment}"]["arrivalPosition"]]["iataCode"]
              flight_detail["routes"] << route
            end

          end
          dump << flight_detail
        end
        Flight.create(:name => name, :source => source, :destination => destination, :source_iata_code => source_iata_code, :destination_iata_code => destination_iata_code, :dump => dump.to_json)
      end
    end

    task get_train_details: :environment do 
      cities_name = ["London","Paris","Rome","Dublin","Madrid","Barcelona","Frankfurt","Milan","Athens","Amsterdam"]
      cities = ["LHR","CDG","FCO","DUB","MAD","BCN","FRA","MXP","ATH","AMS"]
      city_combination =  cities_name.permutation(2).to_a 
      city_combination.each do |city|
        @count = 0
        arrival = City.find_by(:name => city[0]).city_id
        departure = City.find_by(:name => city[1]).city_id

        @cookie = '_go_client_id=CvAA8lmyI02O9XSzAw6LAg==; _fsid=sc8mhqboqj4dq9fnqc1o3hni35; discountTooltipShown=true; cookie-policy-banner=true; goeuroapi-backend=29306ba48f2fe93936bd4a09c2b08658c5477f7c; cookiePal=old; farm_identifier=EU; X-Backend-Server=search-prod-eu-2|WbN0c|WbN0c; __utmt=1; optimizelySegments=%7B%22506211048%22%3A%22search%22%2C%22506270641%22%3A%22gc%22%2C%22506290955%22%3A%22false%22%2C%225278930068%22%3A%22none%22%2C%225382050211%22%3A%22com%22%7D; optimizelyBuckets=%7B%7D; optimizelyEndUserId=oeu1504846671274r0.38365949898482987; _uetsid=_uetfe9bd9b1; __utma=172288693.701171210.1504846669.1504932961.1504933001.5; __utmb=172288693.2.10.1504933001; __utmc=172288693; __utmz=172288693.1504846669.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); _ceg.s=ow00b5; _ceg.u=ow00b5; _sp_id.a63e=5deecb03-1ee7-4b6d-a96a-fcb59dff12af.1504846670.4.1504936338.1504933032.d7c08e7b-8f46-4034-bbc2-f5911f7e6493; _sp_ses.a63e=*; rollout_GA=GA1.2.701171210.1504846669; rollout_GA_gid=GA1.2.1171569205.1504846670; sp=25ac56c5-c007-454d-b311-15c1a63d4dc7; __zlcmid=iPgjMkr39wEF2g; X-Ingress=k8s-prod-eu-1|WbODE|WbN0Y'


        @user_agent = ["Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; en-US) AppleWebKit/534.3 (KHTML, like Gecko) Chrome/6.0.464.0 Safari/534.3",
          "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.13 (KHTML, like Gecko) Chrome/9.0.597.15 Safari/534.13",
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.835.186 Safari/535.1",
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.874.54 Safari/535.2",
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.36 Safari/535.7",
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_0) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1063.0 Safari/536.3",
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.4 (KHTML like Gecko) Chrome/22.0.1229.79 Safari/537.4",
          "Mozilla/5.0 (Macintosh; U; Mac OS X Mach-O; en-US; rv:2.0a) Gecko/20040614 Firefox/3.0.0 ",
          "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10.5; en-US; rv:1.9.0.3) Gecko/2008092414 Firefox/3.0.3",
          "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1) Gecko/20090624 Firefox/3.5",
          "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.14) Gecko/20110218 AlexaToolbar/alxf-2.0 Firefox/3.6.14",
          "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10.5; en-US; rv:1.9.2.15) Gecko/20110303 Firefox/3.6.15",
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:5.0) Gecko/20100101 Firefox/5.0",

          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0) Gecko/20100101 Firefox/9.0",
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2; rv:10.0.1) Gecko/20100101 Firefox/10.0.1",
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20120813 Firefox/16.0",
          "Mozilla/4.0 (compatible; MSIE 5.15; Mac_PowerPC)",
          "Opera/9.0 (Macintosh; PPC Mac OS X; U; en)",
          "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/125.2 (KHTML, like Gecko) Safari/85.8",
          "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/125.2 (KHTML, like Gecko) Safari/125.8",
          "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; fr-fr) AppleWebKit/312.5 (KHTML, like Gecko) Safari/312.3",
          "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/418.8 (KHTML, like Gecko) Safari/419.3"]

          @uAgent = @user_agent.sample
          @search_id = HTTParty.post("https://www.goeuro.com/GoEuroAPI/rest/api/v5/searches",
          { 
            :body => {"searchOptions" => {"departurePosition" => {"id" => arrival},"arrivalPosition" => {"id" => departure},"travelModes" => ["Flight","Train","Bus"],"departureDate" => "2017-09-09","passengers" => [{"age" => 12,"discountCards" => []}],"userInfo" => {"identifier" => "0.hkfmyj74wa9","domain" => ".com","locale" => "en","currency" => "EUR"},"abTestParameters" => ["","APIV5_TRIGGER"]}}.to_json,
            :headers => { 'Content-Type' => 'application/json', 'Cookie' => @cookie, 'User-Agent' => @uAgent }
            }).parsed_response["searchId"]

          puts @search_id
          sleep(2.0)
          response = get_response("train")
          name = response["positions"][response["query"]["departurePosition"]]["name"] + " - " + response["positions"][response["query"]["arrivalPosition"]]["name"]
          puts name
          source = response["positions"][response["query"]["departurePosition"]]["name"]
          destination = response["positions"][response["query"]["arrivalPosition"]]["name"]

          dump = []
          puts response["outbounds"].count
          response["outbounds"].each do |key,value|
            train_detail = {"routes" => []}
            train_detail["train"] = response["companies"][value["companyId"]]["name"]
            train_detail["duration"] = value["duration"]
            train_detail["departureTime"] = value["departureTime"]
            train_detail["arrivalTime"] = value["arrivalTime"]
            train_detail["stops"] = value["stops"]
            train_detail["price"] = value["price"]
            if value["segments"].count > 1
              value["segments"].each do |segment|
                route = {}
                route["name"] = response["positionReport"][response["segmentDetails"]["#{segment}"]["arrivalPosition"]]["name"]
                train_detail["routes"] << route
              end

            end
            dump << train_detail
          end
          Train.create(:name => name, :source => source, :destination => destination, :dump => dump.to_json)
        end
      end

      def get_response(mode)
        sleep(2.0)
        response = HTTParty.get("https://www.goeuro.com/GoEuroAPI/rest/api/v5/results?price_from=1&stops=0%7C1%7C2%3B-1&travel_mode=#{mode}&limit=30&offset=0&position_report_enabled=true&all_positions=true&include_price_details=true&include_transit=false&include_nearby_airports=null&sort_by=price&sort_variants=price&use_stats=true&use_recommendation=true&search_id=#{@search_id}",{:headers =>{'Content-Type' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8', 'Cookie' => @cookie, 'User-Agent' => @uAgent}})
        @count += 1
        if response["outbounds"].count > 0 || @count > 10
          return response
        else
          @uAgent = @user_agent.sample
          get_response(mode)
        end
      end

    end



