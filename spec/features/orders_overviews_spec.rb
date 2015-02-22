require 'rails_helper'

feature "OrdersOverviews", :type => :feature do
  let(:event_other) {create(:event_with_products)}
  let(:event_this) {create(:event_with_products)}
  let(:user) { create(:user_that_is_coordinator, event: event_this) }

  before do
    switch_to_subdomain("#{event_this.slack}")
    visit new_user_session_path locale: "en"
    click_link "Accept cookies"

    visit new_user_session_path

    fill_in 'user_email', :with => user.email
    fill_in 'user_password', :with => "12345678"
    click_button 'Sign in'
  end

  it "shows all orders of this event on orders overview" do
    order_other = create(:order_with_sold_products, event: event_other, created_at: Time.now - 1.hour)
    order_this = Array.new
    order_this[0] = create(:order_with_sold_products, event: event_this, created_at: Time.now - 8.hour)
    order_this[1] = create(:order_with_sold_products, event: event_this, created_at: Time.now - 7.hour)
    order_this[2] = create(:order_with_sold_products, event: event_this, created_at: Time.now - 6.hour)
    order_this[3] = create(:order_with_sold_products, event: event_this, created_at: Time.now - 5.hour)
    order_this[4] = create(:order_with_sold_products, event: event_this, created_at: Time.now - 4.hour)
    order_this[5] = create(:order_with_sold_products, event: event_this, created_at: Time.now - 3.hour)
    order_this[6] = create(:order_with_sold_products, event: event_this, created_at: Time.now - 2.hour)
    order_this[7] = create(:order_with_sold_products, event: event_this, created_at: Time.now - 1.hour)

    visit orders_path

    expect(page).not_to have_content "##{order_other.id}"

    for i in 0 .. (order_this.length-1) do
      expect(page.find "tr:nth-child(#{i+2})").to have_content "##{order_this[i].id}"
    end

  end
end
