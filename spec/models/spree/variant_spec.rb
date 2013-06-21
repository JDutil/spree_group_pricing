require 'spec_helper'

describe Spree::Variant do
  it { should have_many(:group_prices) }

  describe '#group_price' do

    context 'discount_type = price' do
      before :each do
        @variant = create :variant, :price => 10
        @variant.group_prices.create! :amount => 9, :discount_type => 'price', :range => '(10+)'
      end

      it 'should use the variants price when it does not match a range' do
        @variant.group_price(1).to_f.should == 10.00
      end

      it 'should use the group price when it does match a range' do
        @variant.group_price(10).to_f.should == 9.00
      end
    end

    context 'discount_type = dollar' do
      before :each do
        @variant = create :variant, :price => 10
        @variant.group_prices.create! :amount => 1, :discount_type => 'dollar', :range => '(10+)'
      end

      it 'should use the variants price when it does not match a range' do
        @variant.group_price(1).to_f.should == 10.00
      end

      it 'should use the group price when it does match a range' do
        @variant.group_price(10).to_f.should == 9.00
      end
    end

    context 'discount_type = percent' do
      before :each do
        @variant = create :variant, :price => 10
        @variant.group_prices.create! :amount => 0.1, :discount_type => 'percent', :range => '(10+)'
      end

      it 'should use the variants price when it does not match a range' do
        @variant.group_price(1).to_f.should == 10.00
      end

      it 'should use the group price when it does match a range' do
        @variant.group_price(10).to_f.should == 9.00
      end
    end

  end

  it '#current_group_price' do
    variant = create(:variant)
    variant.current_group_price.should be_nil
    current_price = variant.group_prices.create! :amount => 9, :discount_type => 'price', :range => '(2..4)'
    next_price = variant.group_prices.create! :amount => 8, :discount_type => 'price', :range => '(5+)'
    order = create(:completed_order_with_totals)
    order.line_items.first.quantity = 2
    order.line_items.first.variant = variant
    order.save
    variant.current_group_price.should eql(current_price)
  end

  it '#next_group_price' do
    variant = create(:variant)
    variant.next_group_price.should eql(nil)
    current_price = variant.group_prices.create! :amount => 9, :discount_type => 'price', :range => '(2..4)'
    next_price = variant.group_prices.create! :amount => 8, :discount_type => 'price', :range => '(5+)'
    variant.next_group_price.should eql(current_price)
    order = create(:completed_order_with_totals)
    order.line_items.first.quantity = 2
    order.line_items.first.variant = variant
    order.save
    variant.next_group_price.should eql(next_price)
    order = create(:completed_order_with_totals)
    order.line_items.first.quantity = 4
    order.line_items.first.variant = variant
    order.save
    variant.next_group_price.should eql(nil)
  end

  it '#orders_until_next_group_price' do
    variant = create(:variant)
    variant.group_prices.create! :amount => 9, :discount_type => 'price', :range => '(2..4)'
    variant.group_prices.create! :amount => 8, :discount_type => 'price', :range => '(5+)'
    order = create(:completed_order_with_totals)
    order.line_items.first.variant = variant
    order.save
    variant.orders_until_next_group_price.should eql(1)
    order = create(:completed_order_with_totals)
    order.line_items.first.quantity = 2
    order.line_items.first.variant = variant
    order.save
    variant.orders_until_next_group_price.should eql(2)
  end

  it '#product_quantity_ordered' do
    variant = create(:variant)
    order = create(:completed_order_with_totals)
    order.line_items.first.quantity = 5
    order.line_items.first.variant = variant
    order.save
    order = create(:completed_order_with_totals)
    order.line_items.first.variant = variant
    order.save
    order = create(:order_with_line_items)
    order.line_items.first.variant = variant
    order.save
    variant.product_quantity_ordered.should eql(6)
  end

end
