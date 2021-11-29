class Product < ApplicationRecord
    has_many :orders
    has_many :distributer_products

    validates :product_name, presence: true
    validates :product_name, uniqueness: true

    # after_commit UpdateUnknownOrdersJob.perform_later, on: :update

    # after_create_commit do
        # UpdateUnknownOrdersJob.perform_later
    # end
end
