FactoryGirl.define do
  factory :user do
    sequence (:email) {|n| "foo#{n}@bar.co"}
    password "12345678"
    confirmed_at Time.now - 1.hour

    factory :user_that_is_cooperator do
      ignore do
        event create(:event)
      end
      after(:create) do |user, evaluator|
        create(:cooperator, user: user, event: evaluator.event)
      end
    end

    factory :user_that_is_coordinator do
      ignore do
        event create(:event)
      end
      after(:create) do |user, evaluator|
        create(:coordinator, user: user, event: evaluator.event)
      end
    end
  end

  factory :event do
    name "Testevent"
    slack "test"
    factory :event_with_products do
      after(:create) do |event, evaluator|
        create_list(:product, 5, event: event)
      end
    end
  end

  factory :cooperator do
    factory :coordinator do
      role :coordinator
    end
    nickname "Test Cooperator"
    role :cooperator
    user
    event
  end

  factory :product do
    name "T-Shirt"
    price 23.05
    tax 19
    description "Hello world"
    quantity 10
    event
  end

  factory :sold_product do
    product
    order
    event
    user
  end

  factory :order do
    event
    user

    factory :order_with_sold_products do
      after(:create) do |order, evaluator|
        create_list(:sold_product, 5, event: order.event, user: order.user, product: order.event.products.first, order: order)
      end
    end
  end

end
