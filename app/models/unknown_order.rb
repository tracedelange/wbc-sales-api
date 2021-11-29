class UnknownOrder < ApplicationRecord
    belongs_to :account
    belongs_to :distributer_product
end
