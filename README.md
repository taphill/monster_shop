# Monster Shop

### Table of Contents
- [Overview](#overview)
- [Design](#design)
  - [Schema](#schema)
  - [Code Snippets](#code-snippets)
  - [Views in Action](#views-in-action)
- [Implementation Instructions](#implementation-instructions)
- [Contributors](#contributors)

***
### Overview
Monster Shop is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can fulfill items in an order; after the last merchant marks their items as 'fulfilled' the order will be able to get "shipped" by an admin. Each user role will have access to some or all CRUD functionality for resources.

**[Check Out our Live Site on Heroku](https://monster-mash.herokuapp.com)**

**Testing Status:**
- *SimpleCov* - 100% Coverage
- *RSpec* - 223 Tests, 0 failures

***
### Design

#### Schema
<img src="https://i.ibb.co/M976m35/schema.png" alt="schema">

#### Code Snippets

#### Views in Action

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

**Environment Requirements**

Check your versions by running `rails -v` and `ruby -v`
- Rails 5.2.4
- Ruby 2.5.3

**Gems**
- `bcrypt`- Password Encryption
- `factorybot` - Seed data creation for testing
- `faker` - Creates fake info for seed data

***
### Contributors
- Joshua Carey (he/him)
  - [Github: jdcarey128](https://github.com/jdcarey128)
- Kate Tester (she/her)
  - [Github: katemorris](https://github.com/katemorris)
- Shaunda Cunningham (she/her)
  - [Github: smcunning](https://github.com/smcunning)
- Taylor Phillips (he/him)
  - [Github: taphill](https://github.com/taphill)
