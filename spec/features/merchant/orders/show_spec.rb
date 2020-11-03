require 'rails_helper'

describe 'as a merchant employee' do
  before :each do
    @merchant_1 = create(:merchant, :with_items, item_count: 3)
    @merchant_2 = create(:merchant, :with_items, item_count: 3)
    @user = create(:user)
    @merchant_employee = create(:user, role: 1, merchant_id: @merchant_1.id)
    @m1_item1 = @merchant_1.items[0]
    @m1_item2 = @merchant_1.items[1]
    @m1_item3 = @merchant_1.items[2]
    @m2_item1 = @merchant_2.items[0]
    @m2_item2 = @merchant_2.items[1]
    @m2_item3 = @merchant_2.items[2]
    @order = create(:order, user: @user)
    @io1 = create(:item_order, order: @order, item: @m1_item1, quantity: 2)
    @io1 = create(:item_order, order: @order, item: @m1_item2, quantity: 2)
    @io1 = create(:item_order, order: @order, item: @m1_item3)
    @io1 = create(:item_order, order: @order, item: @m2_item1)
    @io1 = create(:item_order, order: @order, item: @m2_item2)
  end

  describe 'when I visit an order show page from my dashboard' do
    before :each do
      visit login_path
      fill_in :email, with: @merchant_employee.email
      fill_in :password, with: @merchant_employee.password
      click_button "Login"
      click_on "#{@order.id}"
    end

    it 'has the recipients name and address for this order' do
      within ".order-info" do
        expect(page).to have_content(@order.name)
        expect(page).to have_content(@order.address)
        expect(page).to have_content(@order.city)
        expect(page).to have_content(@order.state)
        expect(page).to have_content(@order.zip)
      end
    end

    it 'only shows items in the order from my merchant' do
      within ".order-items" do
        expect(page).to have_content(@m1_item1.name)
        expect(page).to have_content(@m1_item2.name)
        expect(page).to have_content(@m1_item3.name)
      end
    end

    it 'doesnt show any items being purchased from other merchants' do
      within ".order-items" do
        expect(page).to_not have_content(@m2_item1.name)
        expect(page).to_not have_content(@m2_item2.name)
      end
    end

    it 'shows linked name, image, price and quantity for each item' do
      within "#item-#{@m1_item1.id}" do
        expect(page).to have_content(@m1_item1.name)
        expect(page).to have_xpath("//img[contains(@src,'#{@m1_item1.image}')]")
        expect(page).to have_content(@m1_item1.price)
        expect(page).to have_content(@m1_item1.quantity_ordered(@m1_item1.id))
      end
    end
  end
end
