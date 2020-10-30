module EtsyApi

  #
  class Shop
    include EtsyApi::Element

    #attr_accessor :image_url, :icon_url

    def self.find_by_id(shop_id)
      response = EtsyApi::Request.get("/shops/#{shop_id}");
      Shop.new(response.result)
    end

    def self.find_by_ids(*shop_ids)
      response = EtsyApi::Request.get("/shops/#{shop_ids.join(',')}")
      shops = []
      response.result.each do |shop_data|
        shops << Shop.new(shop_data)
      end
      shops
    end

    def self.all(options = {})
      response = EtsyApi::Request.get("/shops")
      shops = []
      response.result.each do |shop_data|
        shops << Shop.new(shop_data)
      end
      shops
    end


    attr_reader :shop_id, :shop_name, :title, :user_id, :active_listings_count,
                :image_url, :icon_url, :url, :favorers_count, :updated_at, :created_at,
                :message, :announcement

    def initialize(result)
      @shop_id = result['shop_id']
      @shop_name = result['shop_name']
      @title = result['title']
      @user_id = result['user_id']
      @active_listings_count = result['listing_active_count']
      @url = result['url']
      @icon_url = result['icon_url_fullxfull']
      @image_url = result['image_url_760x100']
      @favorers_count = result['num_favorers']
      if result['last_updated_tsz']
        @updated_at = Time.at(result['last_updated_tsz'])
      end
      if result['creation_tsz']
        @created_at =  Time.at(result['creation_tsz'])
      end
      @message = result['sale_message']
      @announcement = result['announcement']
    end

    # def listings(state = nil, options = {})
    #   state = state ? {:state => state} : {}
    #   Listing.find_all_by_shop_id(shop_id, state.merge(options).merge(oauth))
    # end

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

    def about
      About.find_by_shop(self)
    end

  end

end
