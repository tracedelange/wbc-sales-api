class AccountQueriesController < ApplicationController

    def alphabetical_pagination #returns shallow information about a subset of accounts based off a pagination value.

        get_page

        accounts = Account.order("display_name ASC").limit(20).offset(@offset)

        render json: accounts, status: :ok
        
    end

    def query_by_name

        accounts = Account.where('display_name LIKE :snakesearch OR account_name LIKE :upsearch', upsearch: "%#{query_params[:name].upcase}%", snakesearch: "%#{query_params[:name].titleize}%")

        
        render json: accounts


    end

    def most_orders
        accounts = Account.joins(:orders).group('accounts.id').order('count(orders.id) DESC')
        render json: accounts
    end

    private

    def query_params
        params.permit(:page, :name)
    end

    def get_page

        if query_params[:page]
            @page = query_params[:page]
        else
            @page = 0
        end

        @offset = 20 * Integer(@page)
    end
end
