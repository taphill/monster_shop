# Monster Shop

### Table of Contents
- [Overview](#overview)
- [Design](#design)
  - [Schema](#schema)
  - [Code Snippets](#code-snippets)
  - [Views in Action](#views-in-action)
  - [Design Notes](#design-notes)
- [Implementation Instructions](#implementation-instructions)
- [Contributors](#contributors)

***
### Overview
Monster Shop is a fictitious e-commerce platform, driven by MVC design and ReSTful conventions using Rails and PostgreSQL. This application allows for three types of users with different CRUD functionalities specific to their roles using authentication methods: *regular users*, *merchant employees* and an *admin* role with pieces of all functionality. Our application was built over 9 days and covered 54 user stories while using Test-Driven Development. [You can check out the starter repo and associated users stories here.](https://github.com/turingschool-examples/monster_shop_2005)

**[Check Out our Live Site on Heroku](https://monster-mash.herokuapp.com)**

Login as different users using these credentials:

*Regular User*
```
jamesp@gmail.com
password
```

*Merchant Employee*
```
fake.gmail@gmail.com
password1
```

*Admin*
```
admin@example.com
admin
```

**Testing Status:**
- *SimpleCov* - 100% Coverage
- *RSpec* - 223 Tests, 0 failures

***
### Design


#### Schema
<img src="https://i.ibb.co/M976m35/schema.png" alt="schema">

#### Code Snippets
**ActiveRecord Associations**

<img src="https://i.ibb.co/WHG1PgK/conditional-association.png" alt="conditional-association">
<img src="https://i.ibb.co/wL2pBw0/scope-fulfilled.png" alt="scope-fulfilled">

**Namespaced Routes**

<img src="https://i.ibb.co/6WBx6gk/namespaced-routes.png" alt="namespaced-routes">

**ActiveRecord Queries**

<img src="https://i.ibb.co/gR5QDJK/Screen-Shot-2020-11-05-at-5-51-35-PM.png" alt="Screen-Shot-2020-11-05-at-5-51-35-PM">

#### Views in Action

<img src="https://i.ibb.co/TqLW7Dp/Screen-Shot-2020-11-05-at-5-57-32-PM.png" alt="Screen-Shot-2020-11-05-at-5-57-32-PM">

<img src="https://i.ibb.co/yqxXYdp/Screen-Shot-2020-11-05-at-5-57-53-PM.png" alt="Screen-Shot-2020-11-05-at-5-57-53-PM">

<img src="https://i.ibb.co/K06R6f5/Screen-Shot-2020-11-05-at-6-01-14-PM.png" alt="Screen-Shot-2020-11-05-at-6-01-14-PM">

#### Design Notes
- Would have liked to refactor the routes better to use more resources syntax and namespacing.
- We noticed that any type of user, including a visitor, could delete or edit a review. Although not in our user stories, we would have liked to change this functionality so that reviews also belonged to users and only that user or an admin could change their reviews.
- We would have also liked to develop the ability for an admin to change a user role from regular user to merchant and vice versa. This could also include functionality for an application process for a regular user to submit to become a merchant and some sort of user validation for them to become a merchant.

***
### Implementation Instructions
You can check out our Monster Shop! Follow these steps in your command line:

Clone this repo: `git clone git@github.com:katemorris/monster_shop_2005.git`

Install & update gems:
```
bundle install
bundle update    
```
Get your database goin':
```
rails db:{drop,create,migrate,seed}
```

See our tests run:
```
bundle exec rspec
```

**Environment Requirements**

Check your versions by running `rails -v` and `ruby -v`
- Rails 5.2.4
- Ruby 2.5.3

**Gems**
- `capybara` - Application testing and interaction
- `shoulda-matchers` - Simplifies testing syntax
- `bcrypt`- Password Encryption
- `factorybot` - Seed data creation for testing
- `faker` - Creates fake info for seed data

***
### Contributors
- Joshua Carey (he/him)
  - [GitHub: jdcarey128](https://github.com/jdcarey128)
- Kate Tester (she/her)
  - [GitHub: katemorris](https://github.com/katemorris)
- Shaunda Cunningham (she/her)
  - [GitHub: smcunning](https://github.com/smcunning)
- Taylor Phillips (he/him)
  - [GitHub: taphill](https://github.com/taphill)
