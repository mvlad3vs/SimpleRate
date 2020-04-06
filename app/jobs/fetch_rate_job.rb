class FetchRateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    uri = URI('https://www.binance.com/api/v3/ticker/price?symbol=BUSDRUB')
    response = Net::HTTP.get_response(uri)
    results = JSON.parse(response.body)
    new_price = results['price'].to_d
    if new_price > 0
      ticker = Ticker.find_by base_currency: 'USD', quote_currency: 'RUB'
      ticker.price = results['price']
      ticker.save
    end
  end
end
