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
      search_id = HTTParty.post("https://www.goeuro.com/GoEuroAPI/rest/api/v5/searches",
      { 
        :body => {"searchOptions" => {"departurePosition" => {"id" => arrival},"arrivalPosition" => {"id" => departure},"travelModes" => ["Flight","Train","Bus"],"departureDate" => "2017-09-09","passengers" => [{"age" => 12,"discountCards" => []}],"userInfo" => {"identifier" => "0.hkfmyj74wa9","domain" => ".com","locale" => "en","currency" => "EUR"},"abTestParameters" => ["","APIV5_TRIGGER"]}}.to_json,
        :headers => { 'Content-Type' => 'application/json', 'Cookie' => '_go_client_id=CvAA8lmyI02O9XSzAw6LAg==; _fsid=sc8mhqboqj4dq9fnqc1o3hni35; discountTooltipShown=true; __utmt=1; log_attribution=701171210.1504932961257; cookie-policy-banner=true; goeuroapi-backend=29306ba48f2fe93936bd4a09c2b08658c5477f7c; cookiePal=old; farm_identifier=EU; X-Backend-Server=search-prod-eu-2|WbN0c|WbN0c; __utma=172288693.701171210.1504846669.1504866170.1504932961.4; __utmb=172288693.3.10.1504932961; __utmc=172288693; __utmz=172288693.1504846669.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); _sp_id.a63e=5deecb03-1ee7-4b6d-a96a-fcb59dff12af.1504846670.3.1504933001.1504869986.d7423cad-ae53-4809-bacc-d58da5aa0976; _sp_ses.a63e=*; optimizelySegments=%7B%22506211048%22%3A%22search%22%2C%22506270641%22%3A%22gc%22%2C%22506290955%22%3A%22false%22%2C%225278930068%22%3A%22none%22%2C%225382050211%22%3A%22com%22%7D; optimizelyBuckets=%7B%7D; sp=25ac56c5-c007-454d-b311-15c1a63d4dc7; optimizelyEndUserId=oeu1504846671274r0.38365949898482987; _uetsid=_uetce8e98c3; _ceg.s=ovzxqi; _ceg.u=ovzxqi; rollout_GA=GA1.2.701171210.1504846669; rollout_GA_gid=GA1.2.1171569205.1504846670; __zlcmid=iPgjMkr39wEF2g; X-Ingress=k8s-prod-eu-1|WbN0p|WbN0Y', 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.79 Safari/537.36', 'Connection' => 'keep-alive', 'Content-Length' => '327', 'Referer' => 'https://www.goeuro.com/travel-search2/results/620828639/train' }
        }).parsed_response["searchId"]

      puts search_id
      response = HTTParty.get("https://www.goeuro.com/GoEuroAPI/rest/api/v5/results?price_from=1&stops=0%7C1%7C2%3B-1&travel_mode=flight&limit=10&offset=0&position_report_enabled=true&all_positions=true&include_price_details=true&include_transit=false&include_nearby_airports=null&sort_by=price&sort_variants=price&use_stats=true&use_recommendation=true&search_id=#{search_id}"),
      { 
        :headers => { 'Content-Type' => 'application/json', 'Cookie' => '_go_client_id=CvAA8lmyI02O9XSzAw6LAg==; _fsid=sc8mhqboqj4dq9fnqc1o3hni35; discountTooltipShown=true; __utmt=1; log_attribution=701171210.1504932961257; cookie-policy-banner=true; goeuroapi-backend=29306ba48f2fe93936bd4a09c2b08658c5477f7c; cookiePal=old; farm_identifier=EU; X-Backend-Server=search-prod-eu-2|WbN0c|WbN0c; __utma=172288693.701171210.1504846669.1504866170.1504932961.4; __utmb=172288693.3.10.1504932961; __utmc=172288693; __utmz=172288693.1504846669.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); _sp_id.a63e=5deecb03-1ee7-4b6d-a96a-fcb59dff12af.1504846670.3.1504933001.1504869986.d7423cad-ae53-4809-bacc-d58da5aa0976; _sp_ses.a63e=*; optimizelySegments=%7B%22506211048%22%3A%22search%22%2C%22506270641%22%3A%22gc%22%2C%22506290955%22%3A%22false%22%2C%225278930068%22%3A%22none%22%2C%225382050211%22%3A%22com%22%7D; optimizelyBuckets=%7B%7D; sp=25ac56c5-c007-454d-b311-15c1a63d4dc7; optimizelyEndUserId=oeu1504846671274r0.38365949898482987; _uetsid=_uetce8e98c3; _ceg.s=ovzxqi; _ceg.u=ovzxqi; rollout_GA=GA1.2.701171210.1504846669; rollout_GA_gid=GA1.2.1171569205.1504846670; __zlcmid=iPgjMkr39wEF2g; X-Ingress=k8s-prod-eu-1|WbN0p|WbN0Y', 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.79 Safari/537.36', 'Connection' => 'keep-alive', 'Content-Length' => '327', 'Referer' => 'https://www.goeuro.com/travel-search2/results/#search_id/train' }
      }
      response = response[0]
      name = response["positions"][response["query"]["departurePosition"]]["name"] + " - " + response["positions"][response["query"]["arrivalPosition"]]["name"]
      puts name
      source = response["positions"][response["query"]["departurePosition"]]["name"]
      destination = response["positions"][response["query"]["arrivalPosition"]]["name"]
      source_iata_code = response["positions"][response["query"]["departurePosition"]]["iataCode"]
      destination_iata_code = response["positions"][response["query"]["arrivalPosition"]]["iataCode"]

      dump = []
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

end