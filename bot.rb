class WhatsAppBot < Sinatra::Base
  use Rack::TwilioWebhookAuthentication, ENV['TWILIO_AUTH_TOKEN'], '/bot'

  post '/bot' do
    body = params["Body"].downcase
    response = Twilio::TwiML::MessagingResponse.new
    response.message do |message|
      if body.include?("מחנה")
        message.body("צריך לעשות תדריך כיבוי אש והסעת חניכים")
        # message.media(Dog.picture)
      end
      if body.include?("טיול")
        message.body("צריך לעשות תדריך מילוי מים והסעת חניכים")
        # message.media(Cat.picture)
      end
      if !(body.include?("מחנה") || body.include?("טיול"))
        message.body("מצטער, אני מכיר רק מחנות וטיולים")
      end
    end
    content_type "text/xml"
    response.to_xml
  end
end

module Dog
  def self.fact
    response = HTTP.get("https://dog-api.kinduff.com/api/facts")
    JSON.parse(response.to_s)["facts"].first
  end

  def self.picture
    response = HTTP.get("https://dog.ceo/api/breeds/image/random")
    JSON.parse(response.to_s)["message"]
  end
end

module Cat
  def self.fact
    response = HTTP.get("https://catfact.ninja/fact")
    JSON.parse(response.to_s)["fact"]
  end

  def self.picture
    response = HTTP.get("https://api.thecatapi.com/v1/images/search")
    JSON.parse(response.to_s).first["url"]
  end
end
