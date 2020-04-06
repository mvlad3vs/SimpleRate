require 'rails_helper'

RSpec.describe Ticker, type: :model do

  it 'valid money attr' do
    ticker = Ticker.create base_currency: 'USD', quote_currency: 'RUB'
    ticker.update price: 100
    expect {ticker.price}.to eq(Money.new(100_00, 'RUB'))
  end

  it 'cannot autoupdated after manual set price' do
    ticker = Ticker.create base_currency: 'USD',
                           quote_currency: 'RUB',
                           price: 33
    ticker.fixed_until = Time.now + 10.minutes
    ticker.price = 100
    expect {
      ticker.save
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
