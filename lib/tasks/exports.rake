require 'csv'

namespace :exports do
  desc "TODO"
  task accounts_by_order: :environment do

    #https://stackoverflow.com/questions/16996618/rails-order-by-results-count-of-has-many-association
    #Company
    # .left_joins(:jobs)
    # .group(:id)
    # .order('COUNT(jobs.id) DESC')
    # .limit(10)

    orders_by_account = Account.where(distributer_id: 2).left_joins(:orders).group(:id).order('COUNT(orders.id) DESC')
    
    to_be_file = [['Account name', 'Order Count Since Jan 1st 2021']]

    for entry in orders_by_account do 
      row = [entry.account_name, entry.orders.count]
      to_be_file.append(row)
    end


    File.write("accounts_by_order.csv", to_be_file.map(&:to_csv).join)

  end

  desc "TODO"
  task accounts_by_unknown_order: :environment do

    #https://stackoverflow.com/questions/16996618/rails-order-by-results-count-of-has-many-association
    #Company
    # .left_joins(:jobs)
    # .group(:id)
    # .order('COUNT(jobs.id) DESC')
    # .limit(10)

    orders_by_account = Account.where(distributer_id: 2).left_joins(:unknown_orders).group(:id).order('COUNT(unknown_orders.id) DESC')
    
    to_be_file = [['Account name', 'Unknown Order Count Since Jan 1st 2021']]

    for entry in orders_by_account do 
      row = [entry.account_name, entry.unknown_orders.count]
      to_be_file.append(row)
    end


    File.write("accounts_by_unknown_orders.csv", to_be_file.map(&:to_csv).join)

  end

end
