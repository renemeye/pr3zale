require 'rails_helper'

feature "OrderConfirmations", :type => :feature do
  let(:event) { create(:event_with_products_and_payment_information) }
  let(:user) { create(:user) }

  before do
    switch_to_subdomain("#{event.slack}")
    visit root_path locale: "en"
    click_link "Accept cookies"

    visit new_user_session_path

    fill_in 'user_email', :with => user.email
    fill_in 'user_password', :with => "12345678"
    click_button 'Log in'
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

  #pending "emails user when tickets are available for download"
end
