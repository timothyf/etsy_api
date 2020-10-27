module EtsyApi

  #
  class Shop
    include EtsyApi::Element

    def self.get_by_id(shop_id)
      response = EtsyApi::Request.get("/shops/#{shop_id}")
      Shop.new(response.result)
    end


    attr_reader :shop_id, :shop_name, :title, :user_id, :active_listings_count

    def initialize(result)
      @shop_id = result['shop_id']
      @shop_name = result['shop_name']
      @title = result['title']
      @user_id = result['user_id']
      @active_listings_count = result['listing_active_count']
      @url = result['url']
      @icon_url = result['icon_url_fullxfull']
      @image_url = result['image_url_760x100']
    end

    def get_listings_active_json
      response = EtsyApi::Request.get("/shops/#{@shop_id}/listings/active")
      response.result
    end

    def get_listings_active
      response = EtsyApi::Request.get("/shops/#{@shop_id}/listings/active")
      listings_json = response.result
      listings = []
      listings_json.each do |item|
        listing = EtsyApi::Listing.new(item)
        listings.push listing
      end
      listings
    end

  end

end
