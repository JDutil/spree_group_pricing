FactoryGirl.define do
  factory :group_price, class: Spree::GroupPrice do
    name '1-5'
    discount_type 'price'
    start_range '1'
    end_range '5'
    amount 10
    sequence(:position) { |n| n }
    association :variant

    trait :price do
      name '10 or more'
      discount_type 'price'
      start_range '10'
      end_range ''
      amount 100
    end

    trait :dollar do
      name 'buy 5 $10 off'
      discount_type 'dollar'
      start_range '5'
      end_range ''
      amount 10
    end

    trait :percent do
      name '2 for 1'
      start_range '2'
      end_range '2'
      discount_type 'percent'
      amount 0.5
    end
  end
end