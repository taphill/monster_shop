require 'rails_helper'


describe "As a user admin" do
  describe "when I visit the merchant index page" do
    it "I can click a merchant name, and see everything on their dashboard" do
      admin = create(:user, role:2)
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant)
      item_2 = create(:item, merchant: merchant)
      item_3 = create(:item, merchant: merchant)

      io_1 = create(:item_order, item: item_1)
      io_2 = create(:item_order, item: item_2)
      io_3 = create(:item_order, item: item_3)

      order_1 = io_1.order
      order_2 = io_2.order
      order_3 = io_3.order
      order_1_date = order_1.created_at.strftime("%m/%d/%Y")
      order_2_date = order_2.created_at.strftime("%m/%d/%Y")
      order_3_date = order_3.created_at.strftime("%m/%d/%Y")

      visit login_path

      fill_in :email, with: admin.email
      fill_in :password, with: 'password'
      click_button 'Login'

      click_link "All Merchants"

      expect(current_path).to eq("/merchants")

      click_on merchant.name

      expect(current_path).to eq("/admin/merchants/#{merchant.id}")

      within ".pending-orders" do
        expect(page).to have_css(".order", count:3)

        expect(page).to have_link(order_1.id)
        expect(page).to have_content(order_1_date)
        expect(page).to have_content(order_1.total_quantity)
        expect(page).to have_content(order_1.grandtotal)

        expect(page).to have_link(order_2.id)
        expect(page).to have_content(order_2_date)
        expect(page).to have_content(order_2.total_quantity)
        expect(page).to have_content(order_2.grandtotal)

        expect(page).to have_link(order_3.id)
        expect(page).to have_content(order_3_date)
        expect(page).to have_content(order_3.total_quantity)
        expect(page).to have_content(order_3.grandtotal)
      end

    end
  end
end
