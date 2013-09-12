Spree::Variant.class_eval do

  has_many :group_prices, :order => :position, :dependent => :destroy
  accepts_nested_attributes_for :group_prices, :allow_destroy => true

  attr_accessible :group_prices_attributes

  validates_associated :group_prices

  def current_group_price
    self.group_prices.each do |group_price|
      if group_price.include?(product_quantity_ordered)
        return group_price
      end
    end
    return nil
  end

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
            return self.price * (1 - (group_price.amount / 100))
          end
        end
      end
      # No price ranges matched.
      return self.price
    end
  end

  def next_group_price
    return nil if self.group_prices.empty?
    self.group_prices.each_with_index do |group_price, index|
      if group_price.include?(product_quantity_ordered)
        return self.group_prices[index + 1]
      end
    end
    return self.group_prices.first
  end

  def orders_until_next_group_price
    count = 0
    if next_group_price.open_ended?
      bound = /\d+/.match(next_group_price.range)[0].to_i
      count = bound - product_quantity_ordered
    else
      count = next_group_price.range.to_range.first.to_i - product_quantity_ordered
    end
    if count > 0
      count
    else
      0
    end
  end

  # Returns the amount of completed
  def product_quantity_ordered
    if is_master?
      Spree::LineItem.where(variant_id: self.id, order_id: Spree::Order.complete.pluck(:id)).sum(:quantity)
    else
      Spree::LineItem.where(variant_id: self.product.variants.pluck(:id), order_id: Spree::Order.complete.pluck(:id)).sum(:quantity)
    end
  end

end
