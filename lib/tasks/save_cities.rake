namespace :save_cities do 
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

  task get_search_id: :environment do 
    arrival = City.find_by(:iata_airport_code => "MAN").city_id
    departure = City.find_by(:iata_airport_code => "EDI").city_id
    search_id = HTTParty.post("https://www.goeuro.com/GoEuroAPI/rest/api/v5/searches",
    { 
      :body => {"searchOptions" => {"departurePosition" => {"id" => arrival},"arrivalPosition" => {"id" => departure},"travelModes" => ["Flight","Train","Bus"],"departureDate" => "2017-09-09","passengers" => [{"age" => 12,"discountCards" => []}],"userInfo" => {"identifier" => "0.hkfmyj74wa9","domain" => ".com","locale" => "en","currency" => "EUR"},"abTestParameters" => ["","APIV5_TRIGGER"]}}.to_json,
      :headers => { 'Content-Type' => 'application/json', 'Cookie' => '_go_client_id=CvAA8lmyI02O9XSzAw6LAg==; cookie-policy-banner=true; cookiePal=old; goeuroapi-backend=b2b3de424aeed2940e6a3083034f330fbb057a89; _fsid=sc8mhqboqj4dq9fnqc1o3hni35; farm_identifier=EU; discountTooltipShown=true; X-Backend-Server=search-prod-eu-2|WbJAA|WbJAA; optimizelySegments=%7B%22506211048%22%3A%22search%22%2C%22506270641%22%3A%22gc%22%2C%22506290955%22%3A%22false%22%2C%225278930068%22%3A%22none%22%2C%225382050211%22%3A%22com%22%7D; optimizelyEndUserId=oeu1504846671274r0.38365949898482987; optimizelyBuckets=%7B%7D; _uetsid=_uet5dd36751; _ceg.s=ovy9z8; _ceg.u=ovy9z8; __zlcmid=iPgjMkr39wEF2g; __utmt=1; __utma=172288693.701171210.1504846669.1504846669.1504846669.1; __utmb=172288693.50.10.1504846669; __utmc=172288693; __utmz=172288693.1504846669.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); optimizelyPendingLogEvents=%5B%5D; _sp_id.a63e=5deecb03-1ee7-4b6d-a96a-fcb59dff12af.1504846670.1.1504856856.1504846670.13474b15-8bb7-4e3b-bb63-5eeeb7316465; _sp_ses.a63e=*; sp=25ac56c5-c007-454d-b311-15c1a63d4dc7; _dc_gtm_UA-35436207-13=1; rollout_GA=GA1.2.701171210.1504846669; rollout_GA_gid=GA1.2.1171569205.1504846670; _gat_UA-35436207-13=1; X-Ingress=k8s-prod-eu-1|WbJLI|WbIjU', 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.79 Safari/537.36', 'Connection' => 'keep-alive', 'Content-Length' => '327', 'Referer' => 'https://www.goeuro.com/travel-search2/results/620828639/train' }
      }).parsed_response["searchId"]

    puts search_id
    response = HTTParty.get("https://www.goeuro.com/GoEuroAPI/rest/api/v5/results?price_from=1&stops=0%7C1%7C2%3B-1&travel_mode=flight&limit=10&offset=0&position_report_enabled=true&all_positions=true&include_price_details=true&include_transit=false&include_nearby_airports=null&sort_by=price&sort_variants=price&use_stats=true&use_recommendation=true&search_id=621293528"),
    { 
      :headers => { 'Content-Type' => 'application/json', 'Cookie' => '_go_client_id=CvAA8lmyI02O9XSzAw6LAg==; cookie-policy-banner=true; cookiePal=old; goeuroapi-backend=b2b3de424aeed2940e6a3083034f330fbb057a89; _fsid=sc8mhqboqj4dq9fnqc1o3hni35; farm_identifier=EU; discountTooltipShown=true; X-Backend-Server=search-prod-eu-2|WbJAA|WbJAA; optimizelySegments=%7B%22506211048%22%3A%22search%22%2C%22506270641%22%3A%22gc%22%2C%22506290955%22%3A%22false%22%2C%225278930068%22%3A%22none%22%2C%225382050211%22%3A%22com%22%7D; optimizelyEndUserId=oeu1504846671274r0.38365949898482987; optimizelyBuckets=%7B%7D; _uetsid=_uet5dd36751; _ceg.s=ovy9z8; _ceg.u=ovy9z8; __zlcmid=iPgjMkr39wEF2g; __utmt=1; __utma=172288693.701171210.1504846669.1504846669.1504846669.1; __utmb=172288693.50.10.1504846669; __utmc=172288693; __utmz=172288693.1504846669.1.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); optimizelyPendingLogEvents=%5B%5D; _sp_id.a63e=5deecb03-1ee7-4b6d-a96a-fcb59dff12af.1504846670.1.1504856856.1504846670.13474b15-8bb7-4e3b-bb63-5eeeb7316465; _sp_ses.a63e=*; sp=25ac56c5-c007-454d-b311-15c1a63d4dc7; _dc_gtm_UA-35436207-13=1; rollout_GA=GA1.2.701171210.1504846669; rollout_GA_gid=GA1.2.1171569205.1504846670; _gat_UA-35436207-13=1; X-Ingress=k8s-prod-eu-1|WbJLI|WbIjU', 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.79 Safari/537.36', 'Connection' => 'keep-alive', 'Content-Length' => '327', 'Referer' => 'https://www.goeuro.com/travel-search2/results/620828639/train' }
      }

    response = response[0]
    name = response["positions"][response["query"]["departurePosition"]]["name"] + " - " + response["positions"][response["query"]["arrivalPosition"]]["name"]
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