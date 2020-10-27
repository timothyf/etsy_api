module EtsyApi

  #
  class Listing
    include EtsyApi::Element

    def self.get_by_id(listing_id)
      response = EtsyApi::Request.get("/listings/#{listing_id}")
      Listing.new(response.result)
    end


    attr_reader :title

    def initialize(result)
      @title = result['title']
    end


  end

end
