require 'rails_helper'

feature "DenyCookies", :type => :feature do
  let(:event) { create(:event_with_products) }

  before do
    switch_to_subdomain("#{event.slack}")
    visit root_path locale: "en"
  end

  it "shows no Cookie policy on every page" do
    expect(page).not_to have_content "EU cookie policy"
  end

  it "shows Cookie policy on login page and shows it again after deny" do
    visit new_user_registration_path
    expect(page).to have_content "EU cookie policy"

    click_on "Deny cookies"

    expect(page).to have_content "EU cookie policy"
  end

  it "shows Cookie policy on login page and return to it after accepting" do
    visit new_user_registration_path
    expect(page).to have_content "EU cookie policy"

    click_on "Accept cookies"

    expect(page.current_path).to eq(new_user_registration_path)
  end

  it "shows Cookie policy on registration page and return to it after accepting" do
    visit new_user_session_path
    expect(page).to have_content "EU cookie policy"

    click_on "Accept cookies"

    expect(page.current_path).to eq(new_user_session_path)
  end


end
