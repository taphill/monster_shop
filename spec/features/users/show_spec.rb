require 'rails_helper'

describe 'as a registered user' do
  before :each do
    @merchant = create(:merchant)
    @user = create(:user)
    @gelatinous_cube = @merchant.items.create(name: "Gelatinous Cube", description: "A ten-foot cube of transparent gelatinous ooze.", price: 100, image: "https://www.epicpath.org/images/thumb/8/80/Gelatinous_cube.jpg/550px-Gelatinous_cube.jpg", inventory: 10)
    @owlbear = @merchant.items.create(name: "Owlbear", description: "A cross between a bear and an owl. Owlbear.", price: 1000, image: "https://static.wikia.nocookie.net/forgottenrealms/images/4/43/Monster_Manual_5e_-_Owlbear_-_p249.jpg/revision/latest?cb=20141113191357", inventory: 1)
    @beholder = @merchant.items.create(name: "Beholder", description: "A floating orb of flesh with a large mouth, single central eye and many smaller eyestalks on top.", price: 10000, image: "https://static.wikia.nocookie.net/forgottenrealms/images/2/2c/Monster_Manual_5e_-_Beholder_-_p28.jpg/revision/latest?cb=20200313153220", inventory: 1)
    @order_1 = Order.create!(name: 'Shaunda', address: '123 Superduper Lane', city: 'Cooltown', state: 'CO', zip: 80247)
    @item_order_1 = @order_1.item_orders.create!(item: @gelatinous_cube, price: @gelatinous_cube.price, quantity: 1)
    @item_order_2 = @order_1.item_orders.create!(item: @owlbear, price: @owlbear.price, quantity: 2)
    @order_2 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    @item_order_3 = @order_2.item_orders.create!(item: @beholder, price: @beholder.price, quantity: 1)
  end

  describe 'when I visit my profile page and have orders in system' do
    it 'has a link called my orders that takes me to /profile/orders' do
      visit login_path

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password

      click_button "Login"
      expect(current_path).to eq(profile_path)

      click_on "My Orders"
      expect(current_path).to eq('/profile/orders')
    end
  end

  describe 'when I visit my profile page and do not have orders in the system' do
    it 'does not have a link called my orders' do
      user_2= create(:user)
      visit login_path

      fill_in :email, with: user_2.email
      fill_in :password, with: user_2.password

      click_button "Login"

      expect(current_path).to eq(profile_path)
      expect(page).to_not have_content("My Orders")
    end
  end
end
