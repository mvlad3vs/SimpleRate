class Ticker < ActiveRecord::Migration[6.0]
  def change
    create_table :tickers do |t|
      t.string :base_currency
      t.string :quote_currency
      t.monetize :price, currency: { present: false }
      t.datetime :fixed_until
      t.datetime :updated_at
    end
  end
end
