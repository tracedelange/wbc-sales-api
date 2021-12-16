class GeocodeAccountsJob < ApplicationJob
  queue_as :default

  def perform(*args)

    geocodeAPI = ENV['GEOCODE_API_KEY']

    accountsWithoutCords = Account.where(latitude: nil)

    accountsWithoutCords.each do |account|

      if account.address != nil && account.city != nil && account.state != nil
        string = account.address + ',+' + account.city + ',+' + account.state

        string = string.gsub(' ', '%20')
        string = string.gsub('"', '%22')
        string = string.gsub('<', '%3C')
        string = string.gsub('>', '%3E')
        string = string.gsub('#', '%23')
        string = string.gsub('%', '%25')
        string = string.gsub('|', '%7C')

        route = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + string + '&key=' + geocodeAPI

        response = HTTParty.get(route)
    
        if response['status'] == 'OK'
          lat = response['results'][0]['geometry']['location']['lat']
          lng = response['results'][0]['geometry']['location']['lng']
    
          account.update(latitude: lat, longitude: lng)

          if account.valid?
            pp 'Account successfully geocoded'
          else
            pp 'Account unsuccessfully geocoded'
          end
        else
          pp 'Invaild response received'
        end


      end

    end
    
  end
end

# Unsafe character	Encoded value
# Space	%20
# "	%22
# <	%3C
# >	%3E
# #	%23
# %	%25
# |	%7C
