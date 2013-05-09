Spree::Variant.class_eval do
  has_many :group_prices, :order => :position, :dependent => :destroy
  accepts_nested_attributes_for :group_prices, :allow_destroy => true

  attr_accessible :group_prices_attributes

  # calculates the price based on quantity
  def group_price(quantity)
    if self.group_prices.count == 0
      return self.price
    else
      self.group_prices.each do |group_price|
        if group_price.include?(quantity)
          case group_price.discount_type
          when 'price'
            return group_price.amount
          when 'dollar'
            return self.price - group_price.amount
          when 'percent'
            return self.price * (1 - group_price.amount)
          end
        end
      end
      # No price ranges matched.
      return self.price
    end
  end

end
