FactoryGirl.define do
  factory :group_price, :class => Spree::GroupPrice do
    amount 10
    discount_type 'price'
    start_range 1
    end_range 5
    association :variant
  end
end
