# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

jj = Distributer.create(name: 'JJ Taylor')
locher = Distributer.create(name: 'Locher Brothers')
wbc = Distributer.create(name: 'WBC')


#create testing user

username = 'tdelange'
email = 'tracedelange@me.com'
cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
password_digest = BCrypt::Password.create(ENV['TEST_USER_PW'], cost: cost)

User.create(username: username, email: email, password_digest: password_digest)


# for n in 0...20
    
#     Account.create(account_name: Faker::Restaurant.name, distributer_id: jj.id)
#     Account.create(account_name: Faker::Restaurant.name, distributer_id: locher.id)
#     Account.create(account_name: Faker::Restaurant.name, distributer_id: wbc.id)

# end


Product.create(product_name: '90K IPA')
Product.create(product_name: '255 Amber Ale')
Product.create(product_name: 'Chocolate Peanut Butter Porter')
Product.create(product_name: 'Flashpoint Cream Ale')
Product.create(product_name: 'WacTown Wheat')
Product.create(product_name: 'Carver County Kolsch')
Product.create(product_name: 'Raspberry Blonde')
Product.create(product_name: 'Cookies and Cream Milk Stout')


# for n in 0...1000

#     Account.all.sample.orders.create(sale_date: Faker::Date.backward, product_id: Product.all.sample.id)

# end