class OrderQueriesController < ApplicationController


    def show


        accounts = Account.all.sample

        render json: accounts, serializer: OrderQuerySerializer

    end


end
