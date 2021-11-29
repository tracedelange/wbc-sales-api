class ParseJjReportJob < ApplicationJob
  queue_as :default

  
  def perform(*args)

    # Do something later
    records = Csv.read('11-15-2021-jj.csv')

    puts records

  end
end
