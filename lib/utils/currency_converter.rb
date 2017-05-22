module CurrencyConverter
  def self.convert(amount, currency, date = nil)
    response = Faraday.get "http://www.apilayer.net/api/live?access_key=#{ENV['CURRENCY_LAYER_KEY']}"
  end
end