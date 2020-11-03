# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
bike = bike_shop.items.create(name: "Mountain Bike", description: "An amazing bike!", price: 2100, image: "https://www.bigandtallbike.com/assets/images/BIG%20six%20S%20tube%20gray%20ISO%202400px.png", inventory: 2)
brakes = bike_shop.items.create(name: "Brakes", description: "Outstanding brakes!", price: 200, image: "https://content.backcountry.com/images/items/900/SHI/SHIU18H/BLA.jpg", inventory: 8)
frame = bike_shop.items.create(name: "Frame", description: "You'll love thif frame!", price: 1000, image: "https://content.backcountry.com/images/items/900/SNZ/SNZK145/HIGBLU.jpg", inventory: 4)
helmet = bike_shop.items.create(name: "Helmet", description: "Protect you head!", price: 150, image: "https://www.rei.com/media/f16a435f-6235-476d-85df-83115eb0ea8f?size=784x588", inventory: 10)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
frisbee = dog_shop.items.create(name: "Frisbee", description: "You can't beat the classics!", price: 12, image: "https://img.chewy.com/is/image/catalog/59178_MAIN._AC_SL1500_V1518037644_.jpg", inventory: 14)
tennis_balls = dog_shop.items.create(name: "Tennis Balls", description: "Dogs love tennis balls!", price: 4, image: "https://www.tennisexpress.com/prodimages/45486-DEFAULT-l.jpg", inventory: 24)
rope_ball = dog_shop.items.create(name: "Rope Ball", description: "Long lasting!", price: 6, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTwfiN0gFv8L9fNBhqq-gJck51PZqIlTOifLw&usqp=CAU", inventory: 12)

#order
# order = Order.create(name: "Ralph", address: '824 Lawndale Rd.', city: 'Denver', state: 'CO', zip: 80210)
