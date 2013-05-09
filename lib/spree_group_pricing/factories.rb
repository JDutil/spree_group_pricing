FactoryGirl.define do
  factory :group_price, :class => Spree::GroupPrice do
    amount 10
    discount_type 'price'
    range '(1..5)'
    association :variant
  end
end
