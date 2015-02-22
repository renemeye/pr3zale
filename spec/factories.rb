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
    sequence (:name) {|n| "Testevent #{n}"}
    sequence (:slack) {|n| "test#{n}"}
    factory :event_with_products do
      factory :event_with_products_and_payment_information do
        payment_iban "A1234"
        payment_bic "BICFOOBAR"
        payment_receiver "Foo Bar und Co. KG"
      end

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
    sequence (:name) {|n| "T-shirt #{n}"}
    price 23.05
    tax 19
    description "Hello world"
    quantity 100
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
