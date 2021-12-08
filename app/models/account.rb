class Account < ApplicationRecord
    belongs_to :distributer
    has_many :orders, dependent: :destroy
    has_many :unknown_orders, dependent: :destroy

    validates :account_name, presence: true
    validates :account_name, uniqueness: true

end
