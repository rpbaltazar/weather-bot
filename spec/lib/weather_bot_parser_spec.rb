require "spec_helper"

describe WeatherBotParser do
  describe "get forecast" do
    let(:openweather_result) {
      { "cod" => "200",
        "message" => "",
        "list" => [
        {
          "dt"=> (Time.now - 3.minutes).to_i,
          "main"=>{"temp"=>292.77},
          "weather"=> [ {"description"=>"sky is clear"} ]
        },
        {
          "dt"=> (Time.now + 3.hours).to_i,
          "main"=>{"temp"=>320.77},
          "weather"=> [ {"description"=>"the gauls were right!"} ]
        },
        {
          "dt"=> (Time.now + 6.hours).to_i,
          "main"=>{"temp"=>400.77},
          "weather"=> [ {"description"=>"It looks like Zeus is angry"} ]
        },
      ]}
    }
    before do
      allow(OpenWeather::Forecast).to receive(:city).and_return openweather_result
    end

    describe "when location is available on the api" do
      #NOTE: api returns forecast for 3 hour time window
      it "returns a string with the forecast for the closest third hour" do
        weather_forecast = WeatherBotParser.forecast "Coimbra, PT"
        expect(weather_forecast).to eq "Coimbra, PT: Sky is clear. Temp: 19.62ºC"
      end
    end

    describe "when location is not found by the api" do
      let(:openweather_result) { {"message"=>"", "cod"=>"404"} }
      let(:wrong_location) { "Silly location" }
      it "returns an error message" do
        weather_forecast = WeatherBotParser.forecast wrong_location
        expect(weather_forecast).to eq "We still can't tell you the weather for #{wrong_location}"
      end
    end
  end
end
