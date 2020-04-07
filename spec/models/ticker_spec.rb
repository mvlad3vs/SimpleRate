require 'rails_helper'

RSpec.describe Ticker, type: :model do
  let(:ticker) {Ticker.create base_currency: 'USD',
                              quote_currency: 'RUB',
                              price: 33}
  it 'valid money attr' do
    ticker.update price: 100
    expect(ticker.price).to eq(Money.new(100_00, 'RUB'))
  end

  it 'accept only possitive values' do
    ticker.update price: -100
    expect(ticker.errors[:price]).to include("must be greater than or equal to 0")
  end

  it 'reject changes after manual set price' do
    ticker.update fixed_until: Time.current + 10.minutes
    ticker.price = 100
    expect { ticker.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'accept changes when date set at past' do
    ticker.fixed_until = Time.current - 10.minutes
    ticker.price = 110
    expect(ticker.price).to eq(Money.new(110_00, 'RUB'))
  end
end
