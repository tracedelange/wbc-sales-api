class Distributer < ApplicationRecord
    has_many :report_receipts
    has_many :accounts
    has_many :distributer_products
    has_many :unknown_orders
    has_many :orders, through: :accounts

    validates :name, uniqueness: true

end
