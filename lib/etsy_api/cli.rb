require 'thor'
require 'etsy_api'

module EtsyApi
  class CLI < Thor

    desc "portray ITEM", "Determines if a piece of food is gross or delicious"
    def portray(name)
      puts EtsyApi::Request.portray(name)
    end

  end
end
