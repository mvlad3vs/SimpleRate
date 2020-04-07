class Ticker < ApplicationRecord
  monetize :price_cents,
           with_model_currency: :quote_currency,
           numericality: {
               greater_than_or_equal_to: 0
           }

  validate :price_not_fixed, if: :fixed_until_was
  before_save :broadcast_changes, if: :price_cents_changed?

  def pair
    "#{base_currency}/#{quote_currency}"
  end


  private

  def price_not_fixed
    if fixed_until > Time.current
      self.price_cents = price_cents_was
      errors.add :price, :invalid
    else
      self.fixed_until = nil
    end
  end

  def broadcast_changes
    ActionCable.server.broadcast(
        "rate_channel",
        price: price.to_s
    )
  end

end
