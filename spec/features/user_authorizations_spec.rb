require 'rails_helper'

RSpec.describe "User authorization", :type => :feature do
  describe "unauthenticated users" do
    let(:event) { create(:event_with_products) }
    let(:user) { create(:user_that_is_cooperator, event: event) }
    let(:product) { create :product }
    let(:cooperator) { create :cooperator }
    let(:order) { create :order_with_sold_products, event: event }

    unauthorized_message = "You are not authorized to access this page."

    before do
      switch_to_subdomain("#{event.slack}")

      visit new_user_session_path locale: "en"
      click_link "Accept cookies"

    end

    it "can see root page" do
      visit root_path locale: "en"
      expect(page).not_to have_content(unauthorized_message)
    end

    describe "checking products" do
      it "can see products list" do
        visit products_path
        expect(page).not_to have_content(unauthorized_message)
      end

      it "can see products show page" do
        visit product_path(event.products.last)
        expect(page).not_to have_content(unauthorized_message)
      end

      it "can't see edit product page" do
        visit edit_product_path(event.products.last)
        expect(page).to have_content(unauthorized_message)
      end

      it "can't see new product page" do
        visit new_product_path
        expect(page).to have_content(unauthorized_message)
      end
    end

    describe "checking cooperators" do
      it "can't see cooperators list" do
        visit cooperators_path
        expect(page).to have_content(unauthorized_message)
      end

      it "can't see cooperators show page" do
        visit cooperator_path(user.cooperations.first)
        expect(page).to have_content(unauthorized_message)
      end

      it "can't see edit cooperator page" do
        visit edit_cooperator_path(user.cooperations.first)
        expect(page).to have_content(unauthorized_message)
      end

      it "can't see new cooperator page" do
        visit new_cooperator_path
        expect(page).to have_content(unauthorized_message)
      end
    end

    describe "checking validations" do
      it "can't see validation login-qr-code" do
        visit validation_index_path
        expect(page).to have_content(unauthorized_message)
      end
      it "can't see anything on a validation url" do
        visit validation_path(sold_product_id: order.sold_products.first.product.id, verification_token: order.sold_products.first.verification_token)
        expect(page).to have_content(unauthorized_message)
      end
    end

    describe "checking sensitive pages" do
      it "can't see orders overview page" do
        visit orders_path
        expect(page).to have_content(unauthorized_message)
      end

      it "can't see sold_overview page" do
        visit sold_overview_path
        expect(page).to have_content(unauthorized_message)
      end
    end
  end

  #########

  describe "authenticated normal users" do
    let(:event) { create(:event_with_products) }
    let(:user) { create(:user) }
    let(:product) { create :product }
    let(:cooperator) { create :cooperator }
    let(:order) { create :order_with_sold_products, event: event }

    unauthorized_message = "You are not authorized to access this page."

    before do
      switch_to_subdomain("#{event.slack}")
      visit new_user_session_path locale: "en"
      click_link "Accept cookies"

      visit new_user_session_path

      fill_in 'user_email', :with => user.email
      fill_in 'user_password', :with => "12345678"
      click_button 'Sign in'

    end

    it "can see root page" do
      visit root_path
      expect(page).not_to have_content(unauthorized_message)

    end

    describe "checking products" do
      it "can see products list" do
        visit products_path
        expect(page).not_to have_content(unauthorized_message)
      end

      it "can see products show page" do
        visit product_path(event.products.last)
        expect(page).not_to have_content(unauthorized_message)
      end

      it "can't see edit product page" do
        visit edit_product_path(event.products.last)
        expect(page).to have_content(unauthorized_message)
      end

      it "can't see new product page" do
        visit new_product_path
        expect(page).to have_content(unauthorized_message)
      end
    end

    describe "checking cooperators" do
      it "can't see cooperators list" do
        visit cooperators_path
        expect(page).to have_content(unauthorized_message)
      end

      it "can't see cooperators show page" do
        visit cooperator_path(cooperator)
        expect(page).to have_content(unauthorized_message)
      end

      it "can't see edit cooperator page" do
        visit edit_cooperator_path(cooperator)
        expect(page).to have_content(unauthorized_message)
      end

      it "can't see new cooperator page" do
        visit new_cooperator_path
        expect(page).to have_content(unauthorized_message)
      end
    end

    describe "checking validations" do
      it "can't see validation login-qr-code" do
        visit validation_index_path
        expect(page).to have_content(unauthorized_message)
      end
      it "can't see anything on a validation url" do
        visit validation_path(sold_product_id: order.sold_products.first.product.id, verification_token: order.sold_products.first.verification_token)
        expect(page).to have_content(unauthorized_message)
      end
    end

    describe "checking sensitive pages" do
      it "can't see orders overview page" do
        visit orders_path
        expect(page).to have_content(unauthorized_message)
      end

      it "can't see sold_overview page" do
        visit sold_overview_path
        expect(page).to have_content(unauthorized_message)
      end
    end
  end

  #########

  describe "authenticated cooperator" do
    let(:event) { create(:event_with_products) }
    let(:user) { create(:user_that_is_cooperator, event: event) }
    let(:product) { create :product }
    let(:cooperator) { create :cooperator }
    let(:order) { create :order_with_sold_products, event: event }

    unauthorized_message = "You are not authorized to access this page."

    before do
      switch_to_subdomain("#{event.slack}")
      visit new_user_session_path locale: "en"
      click_link "Accept cookies"

      visit new_user_session_path

      fill_in 'user_email', :with => user.email
      fill_in 'user_password', :with => "12345678"

      click_button 'Sign in'
    end

    it "can see root page" do
      visit root_path locale: "en"
      expect(page).not_to have_content(unauthorized_message)
    end

    describe "checking products" do
      it "can see products list" do
        visit products_path
        expect(page).not_to have_content(unauthorized_message)
      end

      it "can see products show page" do
        visit product_path(event.products.last)
        expect(page).not_to have_content(unauthorized_message)
      end

      it "can't see edit product page" do
        visit edit_product_path(event.products.last)
        expect(page).to have_content(unauthorized_message)
      end

      it "can't see new product page" do
        visit new_product_path
        expect(page).to have_content(unauthorized_message)
      end
    end

    describe "checking cooperators" do
      it "can't see cooperators list" do
        visit cooperators_path
        expect(page).to have_content(unauthorized_message)
      end

      it "can't see cooperators show page" do
        visit cooperator_path(user.cooperations.first)
        expect(page).to have_content(unauthorized_message)
      end

      it "can't see edit cooperator page" do
        visit edit_cooperator_path(user.cooperations.first)
        expect(page).to have_content(unauthorized_message)
      end

      it "can't see new cooperator page" do
        visit new_cooperator_path
        expect(page).to have_content(unauthorized_message)
      end
    end

    describe "checking validations" do
      it "can see validation login-qr-code" do
        visit validation_index_path
        expect(page).not_to have_content(unauthorized_message)
      end
      it "can see and issue a ticket on a validation url" do
        order.purchase
        visit validation_path(sold_product_id: order.sold_products.first.id, verification_token: order.sold_products.first.verification_token)
        expect(page).not_to have_content(unauthorized_message)
        click_link_or_button "Use it!"
        expect(page).to have_content("Successfully used '#{order.sold_products.first.former_product.name}';")
      end
    end

    describe "checking sensitive pages" do
      it "can't see orders overview page" do
        visit orders_path
        expect(page).to have_content(unauthorized_message)
      end

      it "can't see sold_overview page" do
        visit sold_overview_path
        expect(page).to have_content(unauthorized_message)
      end
    end
  end

  #########

  describe "authenticated coordinator" do
    let(:event) { create(:event_with_products) }
    let(:user) { create(:user_that_is_coordinator, event: event) }
    let(:product) { create :product }
    let(:cooperator) { create :cooperator }
    let(:coordinator) { create :cooperator, role: :coordinator }
    let(:order) { create :order_with_sold_products, event: event }

    unauthorized_message = "You are not authorized to access this page."

    before do
      switch_to_subdomain("#{event.slack}")
      visit new_user_session_path locale: "en"
      click_link "Accept cookies"

      visit new_user_session_path

      fill_in 'user_email', :with => user.email
      fill_in 'user_password', :with => "12345678"
      click_button 'Sign in'

    end

    it "can see root page" do
      visit root_path locale: "en"
      expect(page).not_to have_content(unauthorized_message)

    end

    describe "checking products" do
      it "can see products list" do
        visit products_path
        expect(page).not_to have_content(unauthorized_message)
      end

      it "can see products show page" do
        visit product_path(event.products.last)
        expect(page).not_to have_content(unauthorized_message)
      end

      it "can see edit product page" do
        visit edit_product_path(event.products.last)
        expect(page).not_to have_content(unauthorized_message)
      end

      it "can see new product page" do
        visit new_product_path
        expect(page).not_to have_content(unauthorized_message)
      end
    end

    describe "checking cooperators" do
      it "can see cooperators list" do
        visit cooperators_path
        expect(page).not_to have_content(unauthorized_message)
      end

      it "can see cooperators show page" do
        visit cooperator_path(user.cooperations.first)
        expect(page).not_to have_content(unauthorized_message)
      end

      it "can see edit cooperator page" do
        visit edit_cooperator_path(user.cooperations.first)
        expect(page).not_to have_content(unauthorized_message)
      end

      it "can see new cooperator page" do
        visit new_cooperator_path
        expect(page).not_to have_content(unauthorized_message)
      end
    end

    describe "checking validations" do
      it "can see validation login-qr-code" do
        visit validation_index_path
        expect(page).not_to have_content(unauthorized_message)
      end
      it "can see and issue a ticket on a validation url" do
        order.purchase
        visit order_path(order)
        visit validation_path(sold_product_id: order.sold_products.first.id, verification_token: order.sold_products.first.verification_token)
        expect(page).not_to have_content(unauthorized_message)
        click_link_or_button "Use it!"
        expect(page).to have_content("Successfully used '#{order.sold_products.first.former_product.name}';")
      end
    end

    describe "checking sensitive pages" do
      it "can see orders overview page" do
        visit orders_path
        expect(page).not_to have_content(unauthorized_message)
      end

      it "can see sold_overview page" do
        visit sold_overview_path
        expect(page).not_to have_content(unauthorized_message)
      end
    end
  end


end
