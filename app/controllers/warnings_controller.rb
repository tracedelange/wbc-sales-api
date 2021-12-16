class WarningsController < ApplicationController


    def index

        #return distributors that have unassigned distributor products
        #return accounts that do not have premise types defined or display names

        unassigned_products = DistributerProduct.where(product_id: nil).count
        accounts_without_display_names = Account.where(display_name: nil).count


        render json: {'unassigned_products' => unassigned_products, 'accounts_without_display_names' => accounts_without_display_names}

    end


end
