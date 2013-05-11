module Spree
  module Admin
    class GroupPricesController < Spree::Admin::ResourceController

      belongs_to 'spree/variant'

      def destroy
        @group_price = Spree::GroupPrice.find(params[:id])
        @group_price.destroy
        render :nothing => true
      end

      def index
        @product = @variant.product
        @variant.group_prices.build if @variant.group_prices.empty?
      end

    end
  end
end
