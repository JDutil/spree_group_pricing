require 'spec_helper'

describe Spree::LineItem do
  before :each do
    @order = create(:order)
    @variant = create(:variant, :price => 10)
    @variant.group_prices.create! :amount => 9, :discount_type => 'price', :range => '(2..4)'
    @variant.group_prices.create! :amount => 8, :discount_type => 'price', :range => '(5+)'
    @order.contents.add(@variant, 1)
    @line_item = @order.line_items.first
  end

  it 'should update the line item price when the quantity changes to match a range simply by quantity' do
    @line_item.price.to_f.should == 10.00
    @order.contents.add(@variant, 1)
    @order.line_items.first.price.to_f.should == 9.00
  end

  it 'should update the line item price when the quantity changes to match a range with quantity and past orders' do
    order = create(:completed_order_with_totals)
    order.line_items.first.variant = @variant
    order.save
    order = create(:completed_order_with_totals)
    order.line_items.first.variant = @variant
    order.save
    order = create(:completed_order_with_totals)
    order.line_items.first.variant = @variant
    order.save
    @line_item.price.to_f.should == 10.00
    @order.contents.add(@variant, 1)
    @order.line_items.first.price.to_f.should == 8.00
  end
end
