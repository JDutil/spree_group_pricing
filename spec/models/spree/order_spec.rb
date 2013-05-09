require 'spec_helper'

describe Spree::Order do
  before(:each) do
    @order = create(:order)
    @variant = create(:variant, :price => 10)

    @variant_with_prices = create(:variant, :price => 10)
    @variant_with_prices.group_prices << create(:group_price, :range => '(1..5)', :amount => 9, :position => 1)
    @variant_with_prices.group_prices << create(:group_price, :range => '(5..9)', :amount => 8, :position => 2)
  end

  describe "contents.add" do
    it "should use the variant price if there are no group prices" do
      @order.contents.add(@variant, 1)
      @order.line_items.first.price.should == 10
    end

    it "should use the group price if quantity falls within a quantity range of a group price" do
      @variant.group_prices << create(:group_price, :range => '(5..10)', :amount => 9)
      @order.contents.add(@variant_with_prices, 7)
      @order.line_items.first.price.should == 8
    end

    it "should use the variant price if the quantity fails to satisfy any of the group price ranges" do
      @order.contents.add(@variant, 10)
      @order.line_items.first.price.should == 10
    end

    it "should use the first matching group price in the event of more then one matching group prices" do
      @order.contents.add(@variant_with_prices, 5)
      @order.line_items.first.price.to_f.should == 9.0
    end
  end
end
