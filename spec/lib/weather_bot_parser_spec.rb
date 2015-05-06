require "spec_helper"

describe WeatherBotParser do
  describe "get forecast" do
    let(:openweather_result) {
      { "cod" => "200",
        "message" => "",
        #NOTE: api returns forecast for 3 hour time window
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

    let(:weather_forecast) { WeatherBotParser.forecast location }
    let(:location) { "Coimbra, PT" }

    before do
      allow(OpenWeather::Forecast).to receive(:city).and_return openweather_result
    end

    describe "when location is available on the api" do
      it "returns a string with the forecast for the closest third hour" do
        expect(weather_forecast).to eq "#{location}: Sky is clear. Temp: 19.62ºC"
      end
    end

    describe "when location is not found by the api" do
      let(:openweather_result) { {"message"=>"", "cod"=>"404"} }
      let(:location) { "Silly location" }

      it "returns an error message" do
        expect(weather_forecast).to eq "We still can't tell you the weather for #{location}"
      end
    end
  end
end
