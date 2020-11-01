require 'rails_helper'

describe 'As a merchant employee' do
  describe 'when I log in and visit the merchant dashboard' do
    it "I see the name and full address of the merchant I work for" do
      merchant = create(:merchant)
      merchant_user = create(:user, role:1, merchant_id: merchant.id)

      visit login_path

      fill_in :email, with: merchant_user.email
      fill_in :password, with: 'password'
      click_button 'Login'

      expect(current_path).to eq(merchant_path)

      within ".merchant-info" do
        expect(page).to have_content(merchant.name)
        expect(page).to have_content(merchant.address)
        expect(page).to have_content(merchant.city)
        expect(page).to have_content(merchant.state)
        expect(page).to have_content(merchant.zip)
      end
    end

    it "I see a list of pending orders" do
      item_order = create(:item_order)

      merchant = item_order.item.merchant
      merchant_user = create(:user, role:1, merchant_id: merchant.id)
      order_1 = item_order.order

      user = create(:user)
      item_2 = create(:item, merchant: merchant)
      order_2 = create(:order, user: user, status: "packaged")
      item_order_2 = create(:item_order, item: item_2, order: order_2)

      visit login_path

      fill_in :email, with: merchant_user.email
      fill_in :password, with: 'password'
      click_button 'Login'

      within ".pending-orders" do
        expect(page).to have_css(".order", count:1)
        expect(page).to_not have_css("#order-#{order_2.id}")
        # expect(page).to_not have_content(format_date(order_2.created_at))
      end

      within "#order-#{order_1.id}" do
        expect(page).to have_link(order_1.id)
        # expect(page).to have_content(format_date(order_1.created_at))
        expect(page).to have_content(order_1.total_quantity)
        expect(page).to have_content(order_1.grandtotal)
        click_link (order_1.id)
      end

      expect(current_path).to eq("/merchant/orders/#{order_1.id}")
    end

    it "I can click a link to merchant items" do
      merchant = create(:merchant)
      merchant_user = create(:user, role:1, merchant_id: merchant.id)

      visit login_path

      fill_in :email, with: merchant_user.email
      fill_in :password, with: 'password'
      click_button 'Login'

      click_link "My Items"

      expect(current_path).to eq("/merchant/items")
    end

  end
end
