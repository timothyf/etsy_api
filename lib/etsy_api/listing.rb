module EtsyApi

  #
  class Listing
    include EtsyApi::Element

    VALID_STATES = [:active, :expired, :inactive, :sold, :featured, :draft, :sold_out]


    def self.find_by_id(listing_id)
      response = EtsyApi::Request.get("/listings/#{listing_id}")
      Listing.new(response.result)
    end

    def self.find_by_ids(*listing_ids)
      response = EtsyApi::Request.get("/listings/#{listing_ids.join(',')}")
      listings = []
      response.result.each do |listing_data|
        listings << Listing.new(listing_data)
      end
      listings
    end

    def self.find_all_by_shop_id(shop_id, options = {})
      state = options.delete(:state) || :active
      raise(ArgumentError, self.invalid_state_message(state)) unless valid?(state)

      if state == :sold
        sold_listings(shop_id, options)
      else
        response = EtsyApi::Request.get("/shops/#{shop_id}/listings/#{state}")
        listings = []
        response.result.each do |listing_data|
          listings << Listing.new(listing_data)
        end
        listings
      end
    end


    attr_reader :title, :listing_id, :state, :description, :url, :view_count,
                :created_at, :modified_at, :ending_at, :price, :quantity, :currency,
                :tags, :materials, :hue, :saturation, :brightness, :black_and_white,
                :images

    def initialize(result)
      @title = result['title']
      @listing_id = result['listing_id']
      @state = result['state']
      @description = result['description']
      @url  = result['url']
      @view_count = result['views']
      if result['creation_tsz']
        @created_at =  Time.at(result['creation_tsz'])
      end
      if result['last_modified_tsz']
        @modified_at =  Time.at(result['last_modified_tsz'])
      end
      if result['ending_tsz']
        @ending_at =  Time.at(result['ending_tsz'])
      end
      @price = result['price']
      @quantity = result['quantity']
      @currency  = result['currency_code']
      @tags = result['tags']
      @materials = result['materials']
      @hue = result['hue']
      @saturation = result['saturation']
      @brightness = result['brightness']
      @black_and_white = result['is_black_and_white']

      # if result && result["Images"]
      #   @images = result["Images"].map { |hash| Image.new(hash) }
      # else
      #   @images = EtsyApi::Image.find_all_by_listing_id(@listing_id)
      # end
    end


    private

    def self.valid?(state)
      VALID_STATES.include?(state)
    end

    def self.invalid_state_message(state)
      "The state '#{state}' is invalid. Must be one of #{VALID_STATES.join(', ')}"
    end

    def self.sold_listings(shop_id, options = {})
      includes = options.delete(:includes)

      transactions = EtsyApi::Transaction.find_all_by_shop_id(shop_id, options)
      listing_ids  = transactions.map {|t| t.listing_id }.uniq

      options = options.merge(:includes => includes) if includes
      (listing_ids.size > 0) ? Array(find_by_id(listing_ids, options)) : []
    end


  end

end
