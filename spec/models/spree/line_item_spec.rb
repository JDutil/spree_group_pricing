require 'spec_helper'

describe Spree::LineItem do
  before :each do
    @order = create(:order)
    @variant = create(:variant, :price => 10)
    @variant.group_prices.create! :amount => 9, :discount_type => 'price', :range => '(2+)'
    @order.contents.add(@variant, 1)
    @line_item = @order.line_items.first
  end

  it 'should update the line item price when the quantity changes to match a range' do
    @line_item.price.to_f.should == 10.00
    @order.contents.add(@variant, 1)
    @order.line_items.first.price.to_f.should == 9.00
  end
end
