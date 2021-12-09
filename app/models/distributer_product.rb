class DistributerProduct < ApplicationRecord
    belongs_to :product, optional: true
    belongs_to :distributer 
    has_many :unknown_orders

    validates :name, presence: :true

    after_commit :launch_update_orders_job, on: :update 
    
    def launch_update_orders_job
        UpdateUnknownOrdersJob.perform_later
    end

end
