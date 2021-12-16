class TransfersController < ApplicationController


    def create

        file = request.body

        if file
      
            result = JSON.parse(file.string)
      
      
            #Iterate over each customer and determine if distributer name matches any names in current accounts db.
      
            result['customers'].keys.each do |customerKey|
      
              if result['customers'][customerKey]['JJname']
      
                existingData = result['customers'][customerKey]
                presentAccount = Account.find_by(account_name: existingData['JJname'])
      
                if presentAccount
                  coordinates = existingData['coordinates']
                  lat = coordinates.split(',')[0].split(' ')[-1]
                  long = coordinates.split(',')[-1].split(' ')[-1].delete('}')
                  displayName = existingData['displayName']
      
                  # byebug
      
                  presentAccount.update(latitude: Float(lat), longitude: Float(long), display_name: displayName)
      
                  if !presentAccount.valid?
                    pp 'Invalid update'
                    pp presentAccount
                  end
      
                end
      
              end
      
                
            end
      
      
      
            pp result['customers'].keys.length
            pp Account.all.count
      
            # byebug;
      
          else
            pp 'File not found'
          end

    end


end
