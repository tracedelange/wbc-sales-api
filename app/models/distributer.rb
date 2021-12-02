class Distributer < ApplicationRecord
    has_many :accounts
    has_many :distributer_products
    has_many :unknown_orders
    has_many :orders, through: :accounts

end
