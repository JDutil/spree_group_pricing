require 'spec_helper'

describe Spree::Admin::VariantsController do
  stub_authorization!

  describe "PUT #update" do
    it "creates a group price" do
      variant = create :variant

      expect do
        spree_put :update,
          :product_id => variant.product.permalink,
          :id => variant.id,
          :variant => {
            "group_prices_attributes" => {
              "1335830259720" => {
                "name"=>"5-10",
                "discount_type" => 'price',
                "range"=>"5..10",
                "amount"=>"90",
                "position"=>"1",
                "_destroy"=>"false"
              }
            }
          }
      end.to change(variant.group_prices, :count).by(1)
    end
  end
end
