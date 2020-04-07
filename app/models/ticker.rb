class Ticker < ApplicationRecord
  monetize :price_cents,
           with_model_currency: :quote_currency,
           numericality: {
               greater_than_or_equal_to: 0
           }

  validate :price_available_to_change, if: :fixed_until
  before_save :broadcast_changes, if: :price_cents_changed?
  before_save :reset_fixed_timestamp

  def pair
    "#{base_currency}/#{quote_currency}"
  end


  private

  def price_available_to_change
    if fixed_until_was != nil and fixed_until > Time.current
      errors.add :price, :invalid
    end
  end

  def reset_fixed_timestamp
    if fixed_until and not fixed_until_changed? and fixed_until < Time.current
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
