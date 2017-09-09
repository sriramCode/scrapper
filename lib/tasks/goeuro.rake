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

  task get_flight_details: :environment do 
    cities_name = ["London","Paris","Rome","Dublin","Madrid","Barcelona","Frankfurt","Milan","Athens","Amsterdam"]
    cities = ["LHR","CDG","FCO","DUB","MAD","BCN","FRA","MXP","ATH","AMS"]
    city_combination =  cities.combination(2).to_a
    city_combination.each do |city|
      arrival = City.find_by(:iata_airport_code => city[0]).city_id
      departure = City.find_by(:iata_airport_code => city[1]).city_id
      cookie = '_go_client_id=CvAA8lmyI02O9XSzAw6LAg==; _fsid=sc8mhqboqj4dq9fnqc1o3hni35; discountTooltipShown=true; cookie-policy-banner=true; goeuroapi-backend=29306ba48f2fe93936bd4a09c2b08658c5477f7c; cookiePal=old; farm_identifier=EU; X-Backend-Server=search-prod-eu-2|WbN0c|WbN0c; __utmt=1; optimizelySegments=%7B%22506211048%22%3A%22search%22%2C%22506270641%22%3A%22gc%22%2C%22506290955%22%3A%22false%22%2C%225278930068%22%3A%22none%22%2C%225382050211%22%3A%22com%22%7D; optimizelyBuckets=%7B%7D; optimizelyEndUserId=oeu1504846671274r0.38365949898482987; _uetsid=_uetfe9bd9b1; __utma=172288693.701171210.1504846669.1504932961.1504933001.5; __utmb=172288693.2.10.1504933001; __utmc=172288693; __utmz=172288693.1504846669.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); _ceg.s=ow00b5; _ceg.u=ow00b5; _sp_id.a63e=5deecb03-1ee7-4b6d-a96a-fcb59dff12af.1504846670.4.1504936338.1504933032.d7c08e7b-8f46-4034-bbc2-f5911f7e6493; _sp_ses.a63e=*; rollout_GA=GA1.2.701171210.1504846669; rollout_GA_gid=GA1.2.1171569205.1504846670; sp=25ac56c5-c007-454d-b311-15c1a63d4dc7; __zlcmid=iPgjMkr39wEF2g; X-Ingress=k8s-prod-eu-1|WbODE|WbN0Y'

      search_id = HTTParty.post("https://www.goeuro.com/GoEuroAPI/rest/api/v5/searches",
      { 
        :body => {"searchOptions" => {"departurePosition" => {"id" => arrival},"arrivalPosition" => {"id" => departure},"travelModes" => ["Flight","Train","Bus"],"departureDate" => "2017-09-09","passengers" => [{"age" => 12,"discountCards" => []}],"userInfo" => {"identifier" => "0.hkfmyj74wa9","domain" => ".com","locale" => "en","currency" => "EUR"},"abTestParameters" => ["","APIV5_TRIGGER"]}}.to_json,
        :headers => { 'Content-Type' => 'application/json', 'Cookie' => cookie, 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.79 Safari/537.36', 'Connection' => 'keep-alive', 'Content-Length' => '327', 'Referer' => 'https://www.goeuro.com/travel-search2/results/#{search_id}/train' }
        }).parsed_response["searchId"]

      puts search_id
      response = HTTParty.get("https://www.goeuro.com/GoEuroAPI/rest/api/v5/results?price_from=1&stops=0%7C1%7C2%3B-1&travel_mode=flight&limit=10&offset=0&position_report_enabled=true&all_positions=true&include_price_details=true&include_transit=false&include_nearby_airports=null&sort_by=price&sort_variants=price&use_stats=true&use_recommendation=true&search_id=#{search_id}"),
      { 
        :headers => { 'Content-Type' => 'application/json', 'Cookie' => cookie, 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.79 Safari/537.36', 'Connection' => 'keep-alive', 'Content-Length' => '327', 'Referer' => 'https://www.goeuro.com/travel-search2/results/#{search_id}/train' }
      }
      response = response[0]
      name = response["positions"][response["query"]["departurePosition"]]["name"] + " - " + response["positions"][response["query"]["arrivalPosition"]]["name"]
      puts name
      source = response["positions"][response["query"]["departurePosition"]]["name"]
      destination = response["positions"][response["query"]["arrivalPosition"]]["name"]
      source_iata_code = response["positions"][response["query"]["departurePosition"]]["iataCode"]
      destination_iata_code = response["positions"][response["query"]["arrivalPosition"]]["iataCode"]

      dump = []
      binding.pry
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
        binding.pry
      end
      Flight.create(:name => name, :source => source, :destination => destination, :source_iata_code => source_iata_code, :destination_iata_code => destination_iata_code, :dump => dump.to_json)
    end
  end

end


