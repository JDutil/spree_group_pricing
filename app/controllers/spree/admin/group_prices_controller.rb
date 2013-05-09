module Spree
  module Admin
    class GroupPricesController < Spree::Admin::BaseController
      def destroy
        @group_price = Spree::GroupPrice.find(params[:id])
        @group_price.destroy
        render :nothing => true
      end
    end
  end
end
