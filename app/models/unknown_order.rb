class UnknownOrder < ApplicationRecord
    belongs_to :account
    belongs_to :distributer
    belongs_to :distributer_product

    # validates :name, presence: :true

end
