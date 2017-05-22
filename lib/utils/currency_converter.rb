module CurrencyConverter
  def self.convert(amount, currency, year = nil)
    if year.is_a? Integer
      year = 1999 if year < 1999
      d = Date.new(year,1,1)
    else
      raise Exception.new('Invalid call')
    end
    d = d.strftime("%Y-%m-%d")
    api_call = "http://www.apilayer.net/api/historical?access_key=#{ENV['CURRENCY_LAYER_KEY']}&currencies=#{currency}&date=#{d}"
    response = Faraday.get api_call
    if response.status == 200
      json = JSON.parse(response.body)
      change = json["quotes"]["USD#{currency}"]
      result = amount/change
      raise Exception.new(response.status) unless json["success"] == true
    else
      raise Exception.new(response.status)
    end
    result
  end
end