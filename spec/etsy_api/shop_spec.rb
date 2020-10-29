require 'spec_helper'
require 'dotenv/load'


describe EtsyApi::Shop do

  context "The Shop class" do

    it "should be able to find a single shop" do
      shops = mock_request('/shops/littletjane', {}, 'Shop', 'getShop.single.json')
      expect(EtsyApi::Shop.find_by_id('littletjane')).to eql(shops.first)
    end

    it "should be able to find multiple shops" do
      shops = mock_request('/shops/littletjane,reagent', {}, 'Shop', 'getShop.multiple.json')
      expect(EtsyApi::Shop.find_by_ids('littletjane', 'reagent')).to eql(shops)
    end

    it "should be able to find all shops" do
      shops = mock_request('/shops', {}, 'Shop', 'findAllShop.json')
      expect(EtsyApi::Shop.all).to eql(shops)
    end

    it "should return an array of shops if there is only 1 result returned" do
      shops = mock_request('/shops', {}, 'Shop', 'findAllShop.single.json')
      expect(EtsyApi::Shop.all).to eql(shops)
    end

    # it "should allow a configurable limit when finding all shops" do
    #   shops = mock_request('/shops', {:limit => 20, :offset => 0}, 'Shop', 'findAllShop.json')
    #   expect(EtsyApi::Shop.all(:limit => 20)).to eql (shops)
    #   expect(EtsyApi::Shop.all(:limit => 20).count).to eql (20)
    # end
  end

  context "An instance of the Shop class" do
    before(:each) do
      EtsyApi.api_key = ENV['ETSY_API_KEY']
      EtsyApi.access_token = ENV['ETSY_ACCESS_TOKEN']
      EtsyApi.access_secret = ENV['ETSY_ACCESS_SECRET']
      EtsyApi.api_secret = ENV['ETSY_API_SECRET']
    end

    context "with response data" do
      before(:each) do
        data = read_fixture('shop/getShop.single.json')
        @shop = EtsyApi::Shop.new(data.first)
      end

      it "should have a value for :id" do
        expect(@shop.shop_id).to eql(5500349)
      end

      it "should have a value for :user_id" do
        expect(@shop.user_id).to eql(5327518)
      end

      it "should have a value for :image_url" do
        expect(@shop.image_url).to eql("http://ny-image3.etsy.com/iusb_760x100.8484779.jpg")
      end

      it "should have a value for :icon_url" do
        expect(@shop.icon_url).to eql("https://img0.etsystatic.com/173/0/8740774/isla_fullxfull.22739584_nydzpho0.jpg")
      end

      it "should have a value for :url" do
        expect(@shop.url).to eql("http://www.etsy.com/shop/littletjane")
      end

      it "should have a value for :favorers_count" do
        expect(@shop.favorers_count).to eql(684)
      end

      it "should have a value for :active_listings_count" do
        expect(@shop.active_listings_count).to eql(0)
      end

      it "should have a value for :updated_at" do
        expect(@shop.updated_at).to eql(Time.at(1274923984))
      end

      it "should have a value for :created_at" do
        expect(@shop.created_at).to eql(Time.at(1237430331))
      end

      it "should have a value for :name" do
        expect(@shop.shop_name).to eql("littletjane")
      end

      it "should have a value for :title" do
        expect(@shop.title).to eql("a cute and crafty mix of handmade goods.")
      end

      it "should have a value for :message" do
        expect(@shop.message).to eql("thanks!")
      end

      it "should have a value for :announcement" do
        expect(@shop.announcement).to eql("announcement")
      end
    end

    # it "should have a collection of listings" do
    #   shop = EtsyApi::Shop.new({'shop_id' => 1})
    #   #shop.stub(:shop_id).with().and_return(1)
    #
    #   EtsyApi::Listing.stub(:find_all_by_shop_id).with(1, {}).and_return('listings')
    #
    #   expect(shop.listings).to eql('listings')
    # end

    it "gets active listings for a shop JSON" do
      shop = EtsyApi::Shop.find_by_id('20343394')
      listings = shop.get_listings_active_json
      expect(listings).not_to eql(nil)
      expect(listings.count).to be > 0

      # examine a listing
      #expect(listings[0]['title']).to eql('ORCA Boat Sign - Wreckage from JAWS')
      #expect(listings[0]['title']).to eql('Michael Myers Vinyl Decal')
    end
  end

end

#
# module Etsy
#   class ShopTest < Test::Unit::TestCase
#
#
#     context "An instance of the Shop class" do
#
#
#
#       should "have an About object" do
#         shop = Shop.new
#
#         About.stubs(:find_by_shop).with(shop).returns('about')
#
#         shop.about.should == 'about'
#       end
#     end
#
#   end
# end







# RSpec.describe EtsyApi::Shop do
#
#   describe EtsyApi::Shop do
#
#     before(:each) do
#       EtsyApi.api_key = ENV['ETSY_API_KEY']
#       EtsyApi.access_token = ENV['ETSY_ACCESS_TOKEN']
#       EtsyApi.access_secret = ENV['ETSY_ACCESS_SECRET']
#       EtsyApi.api_secret = ENV['ETSY_API_SECRET']
#     end
#
#     it "gets a shop by shop_id" do
#       shop = EtsyApi::Shop.get_by_id('20343394')
#       expect(shop).not_to eql(nil)
#       expect(shop.shop_id).to eql(20343394)
#       expect(shop.shop_name).to eql('TheHorrorWorkshop')
#     end
#
#     it "gets active listings for a shop OBJ" do
#       shop = EtsyApi::Shop.get_by_id('20343394')
#       listings = shop.get_listings_active
#       expect(listings).not_to eql(nil)
#       expect(listings.count).to be > 0
#
#       # examine a listing
#       #expect(listings[0].title).to eql('ORCA Boat Sign - Wreckage from JAWS')
#       expect(listings[0].title).to eql('Michael Myers Vinyl Decal')
#     end
#
#   end
#
# end
