namespace :transfers do
  desc "TODO"
  task import: :environment do

    file = File.read('./12_08_2021_backup.json')

    if file
      
      result = JSON.parse(file)


      #Iterate over each customer and determine if distributer name matches any names in current accounts db.

      result['customers'].keys.each do |customerKey|

        if result['customers'][customerKey]['JJname']

          existingData = result['customers'][customerKey]
          presentAccount = Account.find_by(account_name: existingData['JJname'])

          if presentAccount
            pp existingData['coordinates']
            coordinates = existingData['coordinates']
            lat = coordinates.split(',')[0].split(' ')[-1]
            long = coordinates.split(',')[-1].split(' ')[-1].delete('}')


            byebug;
          end

        end

        # accountSearch = Account.where(account_name: result['customers'][customerKey]['JJname'])
        # if accountSearch.length > 1
        #   pp accountSearch
        # end

          
      end



      pp result['customers'].keys.length
      pp Account.all.count

      # byebug;

    else
      pp 'File not found'
    end


  end

end
