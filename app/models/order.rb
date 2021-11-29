class Order < ApplicationRecord
    belongs_to :account
    belongs_to :product
end


# Book.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight)

# That's a whole lot cleaner over here..........
# I think it's worth it.
#Order.where(sale_date: (Time.now.midnight - 3.months)..Time.now.midnight).order(sale_date: :desc)
