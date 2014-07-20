require 'spec_helper'

feature 'Admin - Group Pricing', js: true do

  stub_authorization!

  given(:product) { create(:product_with_option_types) }

  background do
    visit spree.admin_product_path(product)
  end

  context 'for master variant' do

    scenario 'adding a group price' do
      click_link 'Group Pricing'
      fill_in 'variant[group_prices_attributes][0][name]', with: '10-24'
      select 'Percent Discount', from: 'variant[group_prices_attributes][0][discount_type]'
      fill_in 'variant[group_prices_attributes][0][start_range]', with: '10'
      fill_in 'variant[group_prices_attributes][0][end_range]', with: '24'
      fill_in 'variant[group_prices_attributes][0][amount]', with: '10'
      fill_in 'variant[group_prices_attributes][0][position]', with: '1'
    end

    scenario 'deleting a group price' do
      create(:group_price, variant: product.master)
      click_link 'Group Pricing'
      within_row(1) do
        click_icon 'trash'
      end
      page.has_no_css?('.icon-edit')
    end

    scenario 'editing a group price' do
      create(:group_price, variant: product.master)
      click_link 'Group Pricing'
      fill_in 'variant[group_prices_attributes][0][name]', with: '15-24'
      select 'Percent Discount', from: 'variant[group_prices_attributes][0][discount_type]'
      fill_in 'variant[group_prices_attributes][0][start_range]', with: '15'
      fill_in 'variant[group_prices_attributes][0][end_range]', with: '24'
      fill_in 'variant[group_prices_attributes][0][amount]', with: '15'
      fill_in 'variant[group_prices_attributes][0][position]', with: '2'
      click_button 'Update'
      page.should have_content("Variant \"#{product.name}\" has been successfully updated!")
    end

  end

  context 'for another variant' do

    background do
      product.variants << create(:variant, product: product)
    end

    scenario 'adding a group price' do
      click_link 'Variants'
      within_row(1) do
        click_icon 'edit'
      end
      fill_in 'variant[group_prices_attributes][0][name]', with: '10-24'
      select 'Percent Discount', from: 'variant[group_prices_attributes][0][discount_type]'
      fill_in 'variant[group_prices_attributes][0][start_range]', with: '10'
      fill_in 'variant[group_prices_attributes][0][end_range]', with: '24'
      fill_in 'variant[group_prices_attributes][0][amount]', with: '10'
      fill_in 'variant[group_prices_attributes][0][position]', with: '1'
      click_button 'Update'
      page.should have_content("Variant \"#{product.name}\" has been successfully updated!")
    end

    scenario 'deleting a group price' do
      product.variants.first.group_prices << create(:group_price, variant: product.variants.first)
      click_link 'Variants'
      within_row(1) do
        click_icon 'edit'
      end
      within_row(1) do
        click_icon 'trash'
      end
      click_button 'Update'
      skip 'not sure why routing is getting messed up causing a no variant found error from an AR Not Found error most likely rescued.'
      page.should have_content("Variant \"#{product.name}\" has been successfully updated!")
      click_icon 'edit'
      page.should_not have_content('Remove')
    end

    scenario 'editing a group price' do
      product.variants.first.group_prices << create(:group_price, variant: product.variants.first)
      click_link 'Variants'
      within_row(1) do
        click_icon 'edit'
      end
      fill_in 'variant[group_prices_attributes][0][name]', with: '15-24'
      select 'Percent Discount', from: 'variant[group_prices_attributes][0][discount_type]'
      fill_in 'variant[group_prices_attributes][0][start_range]', with: '15'
      fill_in 'variant[group_prices_attributes][0][end_range]', with: '24'
      fill_in 'variant[group_prices_attributes][0][amount]', with: '15'
      fill_in 'variant[group_prices_attributes][0][position]', with: '2'
      click_button 'Update'
      page.should have_content("Variant \"#{product.name}\" has been successfully updated!")
    end

  end

end
