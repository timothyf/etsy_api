RSpec.describe EtsyApi::Shop do

  describe EtsyApi::Shop do

    before(:each) do
      EtsyApi.api_key = ENV['ETSY_API_KEY']
      EtsyApi.access_token = ENV['ETSY_ACCESS_TOKEN']
      EtsyApi.access_secret = ENV['ETSY_ACCESS_SECRET']
      EtsyApi.api_secret = ENV['ETSY_API_SECRET']
    end

    it "gets a shop by shop_id" do
      shop = EtsyApi::Shop.get_by_id('20343394')
      expect(shop).not_to eql(nil)
      expect(shop.shop_id).to eql(20343394)
      expect(shop.shop_name).to eql('TheHorrorWorkshop')
    end

    it "gets active listings for a shop JSON" do
      shop = EtsyApi::Shop.get_by_id('20343394')
      listings = shop.get_listings_active_json
      expect(listings).not_to eql(nil)
      expect(listings.count).to be > 0

      # examine a listing
      #expect(listings[0]['title']).to eql('ORCA Boat Sign - Wreckage from JAWS')
      expect(listings[0]['title']).to eql('Michael Myers Vinyl Decal')
    end

    it "gets active listings for a shop OBJ" do
      shop = EtsyApi::Shop.get_by_id('20343394')
      listings = shop.get_listings_active
      expect(listings).not_to eql(nil)
      expect(listings.count).to be > 0

      # examine a listing
      #expect(listings[0].title).to eql('ORCA Boat Sign - Wreckage from JAWS')
      expect(listings[0].title).to eql('Michael Myers Vinyl Decal')
    end

  end

end
