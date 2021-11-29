class Account < ApplicationRecord
    belongs_to :distributer
    has_many :orders
    has_many :unknown_orders

end
