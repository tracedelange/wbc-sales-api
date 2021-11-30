class Distributer < ApplicationRecord
    has_many :accounts
    has_many :distributer_products
    has_many :unknown_orders

end
