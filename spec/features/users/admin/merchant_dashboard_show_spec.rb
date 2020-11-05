require 'rails_helper'


describe "As a user admin" do
  describe "when I visit the merchant index page" do
    it "I can click a merchant name, and see everything on their dashboard" do
      admin = create(:user, role:2)
      merchant = create(:merchant, name: "Once Upon a time")
      merchant_2 = create(:merchant)

      item_1 = create(:item, merchant: merchant)
      item_2 = create(:item, merchant: merchant)
      item_3 = create(:item, merchant: merchant)
      item_4 = create(:item, merchant: merchant_2)
      item_5 = create(:item, merchant: merchant_2)
      item_6 = create(:item, merchant: merchant_2)
      item_7 = create(:item, merchant: merchant_2)

      order_1 = create(:order)
      order_2 = create(:order)

      item_order_1 = create(:item_order, order: order_1, item: merchant.items[0])
      item_order_2 = create(:item_order, order: order_1, item: merchant.items[2])
      item_order_3 = create(:item_order, order: order_1, item: merchant_2.items[0])
      item_order_4 = create(:item_order, order: order_1, item: merchant_2.items[1])
      item_order_5 = create(:item_order, order: order_1, item: merchant_2.items[2])
      item_order_6 = create(:item_order, order: order_1, item: merchant_2.items[3])

      item_order_7 = create(:item_order, order: order_2, item: merchant.items[1])
      item_order_8 = create(:item_order, order: order_2, item: merchant_2.items[2])
      item_order_9 = create(:item_order, order: order_2, item: merchant_2.items[3])

      order_1_date = order_1.created_at.strftime("%m/%d/%Y")
      order_2_date = order_2.created_at.strftime("%m/%d/%Y")

      visit login_path

      fill_in :email, with: admin.email
      fill_in :password, with: 'password'
      click_button 'Login'

      click_link "All Merchants"

      expect(current_path).to eq(admin_merchants_path)

      click_link merchant.name

      save_and_open_page
      expect(current_path).to eq("/admin/merchants/#{merchant.id}")

      within ".pending-orders" do
        expect(page).to have_css(".order", count:2)
      end

      within "#order-#{order_1.id}" do
        expect(page).to have_link("#{order_1.id}")
        expect(page).to have_content(order_1_date)
        expect(page).to have_content(merchant.order_item_quantity(order_1))
        expect(page).to have_content(merchant.order_total(order_1))
      end

      within "#order-#{order_2.id}" do
        expect(page).to have_link("#{order_2.id}")
        expect(page).to have_content(order_2_date)
        expect(page).to have_content(merchant.order_item_quantity(order_2))
        expect(page).to have_content(merchant.order_total(order_2))
      end

    end
  end
end
