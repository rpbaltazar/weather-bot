require "spec_helper"

describe WeatherBotParser do
  describe "get forecast" do
    let(:openweather_result) {
      { "list" => [
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
    #NOTE: api returns forecast for 3 hour time window
    it "returns a string with the forecast for the closest third hour" do
      allow(OpenWeather::Forecast).to receive(:city).and_return openweather_result
      weather_forecast = WeatherBotParser.forecast "Coimbra, PT"
      expect(weather_forecast).to eq "Coimbra, PT: Sky is clear. Temp: 19.62ºC"
    end
  end
end
