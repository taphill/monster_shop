require 'rails_helper'

describe 'As a visitor' do
  describe 'when I login correctly' do
    it 'as a default user I am redirected to profile & see a flash message' do
      visit login_path

      user = create(:user)

      fill_in :email, with: user.email
      fill_in :password, with: 'password'
      click_button 'Login'

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Welcome, #{user.name}")
    end

    it 'as a merchant I am redirected to dashboard & see a flash message' do
      visit login_path
      merchant = create(:merchant)
      merchant_employee = create(:user, role: 1, merchant: merchant)

      fill_in :email, with: merchant_employee.email
      fill_in :password, with: 'password'
      click_button 'Login'

      expect(current_path).to eq("/merchant")
      expect(page).to have_content("Welcome, #{merchant_employee.name}")
    end

    it 'as an admin I am redirected to dashboard & see a flash message' do
      visit login_path

      admin = create(:user, role: 2)

      fill_in :email, with: admin.email
      fill_in :password, with: 'password'
      click_button 'Login'

      expect(current_path).to eq("/admin")
      expect(page).to have_content("Welcome, #{admin.name}")
    end
  end

  describe 'when I login with bad credentials' do
    it 'redirects me to login page with flash message' do
      visit login_path

      user = create(:user)

      fill_in :email, with: user.email
      fill_in :password, with: 'password7'
      click_button 'Login'

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Your login credentials were incorrect.")

      fill_in :email, with: "jun.lee@example.com"
      fill_in :password, with: 'password'
      click_button 'Login'

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Your login credentials were incorrect.")
    end
  end

  describe 'as a logged in user' do
    it 'redirects me to my dashboard/profile when I click login' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit login_path
      expect(current_path).to eq("/profile")

      merchant = create(:merchant)
      merchant_employee = create(:user, role: 1, merchant: merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)
      visit login_path
      expect(current_path).to eq("/merchant")

      admin = create(:user, role: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
      visit login_path
      expect(current_path).to eq("/admin")
    end
  end

  describe 'as any user while logged in' do
    it 'Regular User: I can logout and will be redirected to the welcome page with a flash message' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      ogre = megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 5 )
      giant = megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 2 )
      hippo = brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 3 )


      visit "/items"
      click_on "Ogre"
      click_on "Add To Cart"

      within ".topnav" do
        expect(page).to have_content("Cart: 1")
      end

      click_on "Logout"

      expect(current_path).to eq(root_path)
      expect(page).to have_content("You are now logged out.")

      within ".topnav" do
        expect(page).to have_content("Cart: 0")
      end
    end

    it 'Merchant User: I can logout and will be redirected to the welcome page with a flash message' do

      megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      ogre = megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 5 )
      giant = megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 2 )
      hippo = brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 3 )

      user = create(:user, role: 1, merchant_id: megan.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit "/items"
      click_on "Ogre"
      click_on "Add To Cart"

      within ".topnav" do
        expect(page).to have_content("Cart: 1")
      end

      click_on "Logout"

      expect(current_path).to eq(root_path)
      expect(page).to have_content("You are now logged out.")

      within ".topnav" do
        expect(page).to have_content("Cart: 0")
      end
    end

    it 'Admin User: I can logout and will be redirected to the welcome page with a flash message' do
      user = create(:user, role: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      ogre = megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 5 )
      giant = megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 2 )
      hippo = brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', inventory: 3 )

      visit '/admin'

      click_on "Logout"

      expect(current_path).to eq(root_path)
      expect(page).to have_content("You are now logged out.")
    end
  end
end
