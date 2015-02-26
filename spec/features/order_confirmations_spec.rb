require 'rails_helper'

feature "OrderConfirmations", :type => :feature do
  let(:event) { create(:event_with_products_and_payment_information) }
  let(:user) { create(:user) }

  before do
    switch_to_subdomain("#{event.slack}")
    visit new_user_session_path locale: "en"
    click_link "Accept cookies"

    visit new_user_session_path

    fill_in 'user_email', :with => user.email
    fill_in 'user_password', :with => "12345678"
    click_button 'Sign in'
  end

  it "emails user when making a reservation" do
    visit products_path
    expect(page).to have_content(user.email)

    #Fake a reservation process
    page.driver.browser.process_and_follow_redirects(:post, orders_path, :order => {:sold_products_attributes => [{product_id: event.products.last.id}]} )

    expect(page).to have_content("Order ##{Order.last.id}")

    expect(last_email).to have_content(user.email)
    expect(last_email).to have_content(event.payment_iban)
    expect(last_email).to have_content(event.payment_receiver)
    expect(last_email).to have_content(Order.last.sold_products.first.name)
    expect(last_email).to have_content(Order.last.transfer_token)

  end

  it "shows please-pay-until date information user" do
    event.pay_until = Date.today + 5.weeks
    event.save

    #Fake a reservation process
    page.driver.browser.process_and_follow_redirects(:post, orders_path, :order => {:sold_products_attributes => [{product_id: event.products.last.id}]} )
    expect(page).to have_content("pay until #{event.pay_until}")
    expect(last_email).to have_content("pay until #{event.pay_until}")
  end

  it "does not show please-pay-until information if empty" do
    event.pay_until = ""
    event.save

    #Fake a reservation process
    page.driver.browser.process_and_follow_redirects(:post, orders_path, :order => {:sold_products_attributes => [{product_id: event.products.last.id}]} )
    expect(page).not_to have_content("pay until")
    expect(last_email).not_to have_content("pay until")
  end
  it "does not show please-pay-until information if nil" do
    event.pay_until = nil
    event.save

    #Fake a reservation process
    page.driver.browser.process_and_follow_redirects(:post, orders_path, :order => {:sold_products_attributes => [{product_id: event.products.last.id}]} )
    expect(page).not_to have_content("pay until")
    expect(last_email).not_to have_content("pay until")
  end
end
