Spree::Admin::VariantsController.class_eval do

  def edit
    @variant.group_prices.build if @variant.group_prices.empty?
    super
  end

  private

  # this loads the variant for the master variant group price editing
  def load_resource_instance
    parent

    if new_actions.include?(params[:action].to_sym)
      build_resource
    elsif params[:id]
      Spree::Variant.find(params[:id])
    end
  end

  def location_after_save
    if @product.master.id == @variant.id and params[:variant].has_key? :group_prices_attributes
      return spree.admin_product_variant_group_prices_path(@product, @variant)
    end

    super
  end

end
