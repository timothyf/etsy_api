require 'spec_helper'
require 'dotenv/load'
require 'etsy_api/about'
require 'etsy_api/transaction'
require 'etsy_api/image'


describe EtsyApi::Listing do

  before(:each) do
    EtsyApi.api_key = ENV['ETSY_API_KEY']
    EtsyApi.access_token = ENV['ETSY_ACCESS_TOKEN']
    EtsyApi.access_secret = ENV['ETSY_ACCESS_SECRET']
    EtsyApi.api_secret = ENV['ETSY_API_SECRET']
  end

  context "The Listing class" do

    it "should be able to find a single listing" do
      listings = mock_request('/listings/123', {}, 'Listing', 'getListing.single.json')
      expect(EtsyApi::Listing.find_by_id(123)).to eql(listings.first)
    end

    it "should be able to find multiple listings" do
      listings = mock_request('/listings/123,456', {}, 'Listing', 'getListing.multiple.json')
      expect(EtsyApi::Listing.find_by_ids('123', '456')).to eql(listings)
    end

    context "within the scope of a shop" do

      it "should be able to find the first 25 active listings" do
        listings = mock_request('/shops/1/listings/active', {}, 'Listing', 'findAllShopListings.json')
        expect(EtsyApi::Listing.find_all_by_shop_id(1)).to eql(listings)
      end

      it "should be able to find expired listings" do
        listings = mock_request('/shops/1/listings/expired', {}, 'Listing', 'findAllShopListings.json')
        expect(EtsyApi::Listing.find_all_by_shop_id(1, :state => :expired)).to eql(listings)
      end

      it "should be able to find inactive listings" do
        listings = mock_request('/shops/1/listings/inactive', {}, 'Listing', 'findAllShopListings.json')
        expect(EtsyApi::Listing.find_all_by_shop_id(1, :state => :inactive)).to eql(listings)
      end

      it "should be able to find draft listings" do
        listings = mock_request('/shops/1/listings/draft', {}, 'Listing', 'findAllShopListings.json')
        expect(EtsyApi::Listing.find_all_by_shop_id(1, :state => :draft)).to eql(listings)
      end

      it "should be able to find sold_out listings" do
        listings = mock_request('/shops/1/listings/sold_out', {}, 'Listing', 'findAllShopListings.json')
        expect(EtsyApi::Listing.find_all_by_shop_id(1, :state => :sold_out)).to eql(listings)
      end

      it "should be able to find featured listings" do
        listings = mock_request('/shops/1/listings/featured', {}, 'Listing', 'findAllShopListings.json')
        expect(EtsyApi::Listing.find_all_by_shop_id(1, :state => :featured)).to eql(listings)
      end

      # it "should be able to find sold listings" do
      #   transaction_1 = stub(:listing_id => 1)
      #   transaction_2 = stub(:listing_id => 2)
      #   transaction_3 = stub(:listing_id => 1)
      #
      #   transactions = [transaction_1, transaction_2, transaction_3]
      #   listings = mock_request('/shops/1/listings/active', {}, 'Listing', 'findAllShopListings.json')
      #
      #
      #   #mock_request('/shops/1/listings/active', {}, 'Listing', 'findAllShopListings.json')
      #   EtsyApi::Transaction.stub(:find_all_by_shop_id).with(1, {}).and_return(transactions)
      #   EtsyApi::Listing.stub(:find_by_id).with([1, 2], {}).and_return(listings)
      #
      #   expect(EtsyApi::Listing.find_all_by_shop_id(1, :state => :sold)).to eql(['listings'])
      # end


      # it "should defer associations to listings from transaction (sold listings)" do
      #   transaction_1 = stub(:listing_id => 1)
      #   transaction_2 = stub(:listing_id => 2)
      #
      #   Transaction.stubs(:find_all_by_shop_id).with(1, {}).returns [transaction_1, transaction_2]
      #   Listing.stubs(:find).with([1, 2], {:includes => :an_association}).returns(['listings'])
      #
      #   expect(EtsyApi::Listing.find_all_by_shop_id(1, :state => :sold, :includes => :an_association).to eql(['listings'])
      # end

    end

    context "An instance of the Listing class" do

      context "with response data" do
        before :each do
          data = read_fixture('listing/findAllShopListings.json')
          @listing = EtsyApi::Listing.new(data.first)
        end

        it "should have a value for :id" do
          expect(@listing.listing_id).to eql(59495892)
        end

        it "should have a value for :state" do
          expect(@listing.state).to eql('active')
        end

        it "should have a value for :title" do
          expect(@listing.title).to eql("initials carved into tree love stamp")
        end

        it "should have a value for :description" do
          expect(@listing.description).to eql("there! our initials are now carved deeply into this rough tree bark of memory")
        end

        it "should have a value for :url" do
          expect(@listing.url).to eql("http://www.etsy.com/listing/59495892/initials-carved-into-tree-love-stamp")
        end

        it "should have a value for :view_count" do
          expect(@listing.view_count).to eql(37)
        end

        it "should have a value for :created_at" do
          expect(@listing.created_at).to eql(Time.at(1287602289))
        end

        it "should have a value for :modified_at" do
          expect(@listing.modified_at).to eql(Time.at(1287602289))
        end

        it "should have a value for :price" do
          expect(@listing.price).to eql("15.00")
        end

        it "should have a value for :quantity" do
          expect(@listing.quantity).to eql(1)
        end

        it "should have a value for :currency" do
          expect(@listing.currency).to eql("USD")
        end

        it "should have a value for :ending_at" do
          expect(@listing.ending_at).to eql(Time.at(1298178000))
        end

        it "should have a value for :tags" do
          expect(@listing.tags).to eql(%w(tag_1 tag_2))
        end

        it "should have a value for :materials" do
          expect(@listing.materials).to eql(%w(material_1 material_2))
        end

        it "should have a value for :hue" do
          expect(@listing.hue).to eql(0)
        end

        it "should have a value for :saturation" do
          expect(@listing.saturation).to eql(0)
        end

        it "should have a value for :brightness" do
          expect(@listing.brightness).to eql(100)
        end

        it "should have a value for :black_and_white" do
          expect(@listing.black_and_white).to eql(false)
        end

      end

      context "with oauth" do
        # it "should have a collection of images" do
        #   listing = EtsyApi::Listing.new({})
        #   listing.stub(:id).with(no_args).and_return(1)
        #   listing.stub(:token).with(no_args).and_return("token")
        #   listing.stub(:secret).with(no_args).and_return("secret")
        #
        #   EtsyApi::Image.stub(:find_all_by_listing_id).with(1, {access_token: "token", access_secret: "secret"}).and_return('images')
        #
        #   expect(listing.images).to eql('images')
        # end
      end

    end


  end
end


#
#         it "should pass options through to the listing call" do
#           transaction_1 = stub(:listing_id => 1)
#           transaction_2 = stub(:listing_id => 2)
#
#           Transaction.stubs(:find_all_by_shop_id).with(1, {:other => :params}).returns [transaction_1, transaction_2]
#           Listing.stubs(:find).with([1, 2], {:other => :params}).returns(['listings'])
#
#           Listing.find_all_by_shop_id(1, :state => :sold, :other => :params)).to eql(['listings']
#
#         end
#
#         it "should not ask the API for listings if there are no transactions" do
#           Transaction.stubs(:find_all_by_shop_id).with(1, {}).returns([])
#           Listing.expects(:find).never
#           Listing.sold_listings(1, {})
#         end
#
#         it "should be able to override limit and offset" do
#           options = {:limit => 100, :offset => 100}
#           listings = mock_request('/shops/1/listings/active', options, 'Listing', 'findAllShopListings.json')
#           Listing.find_all_by_shop_id(1, options)).to eql(listings
#         end
#
#         it "should raise an exception when calling with an invalid state" do
#           options = {:state => :awesome}
#           lambda { Listing.find_all_by_shop_id(1, options) }.should raise_error(ArgumentError)
#         end
#
#       end
#
#       context "within the scope of a category" do
#         it "should be able to find active listings" do
#           active_listings = mock_request('/listings/active', {:category => 'accessories'}, 'Listing', 'findAllListingActive.category.json')
#           Listing.find_all_active_by_category('accessories')).to eql(active_listings
#         end
#       end
#
#     end
#
#     context "An instance of the Listing class" do
#

#
#       %w(active removed sold_out expired alchemy).each do |state|
#         it "should know that the listing is #{state}" do
#           listing = Listing.new
#           listing.expects(:state).with().returns(state.sub('_', ''))
#
#           listing.send("#{state}?".to_sym).should be(true)
#         end
#
#         it "should know that the listing is not #{state}" do
#           listing = Listing.new
#           listing.expects(:state).with().returns(state.reverse)
#
#           listing.send("#{state}?".to_sym).should be(false)
#         end
#       end
#
#
#       context "without oauth" do
#         it "should have a collection of images" do
#           listing = Listing.new
#           listing.stubs(:id).with().returns(1)
#
#           Image.stubs(:find_all_by_listing_id).with(1, {}).returns('images')
#
#           listing.images).to eql('images'
#         end
#       end
#
#       context "with included images" do
#         it "should not hit the API to get images" do
#           data = read_fixture('listing/getListing.single.includeImages.json')
#           listing = Listing.new(data.first)
#           Request.expects(:get).never
#
#           listing.images
#         end
#       end
#
#       it "should have a default image" do
#         listing = Listing.new
#         listing.stubs(:images).with().returns(%w(image_1 image_2))
#
#         listing.image).to eql('image_1'
#       end
#
#     end
#
#     context "with favorite listings data" do
#         setup do
#           data = read_fixture('listing/findAllShopListings.json')
#           @listing = Listing.new(data.first)
#           listing_1 = stub(:listing_id => @listing.id, :user_id => 1)
#           listing_2 = stub(:listing_id => @listing.id, :user_id => 2)
#           @favorite_listings = [listing_1, listing_2]
#         end
#
#         it "should have all listings" do
#           FavoriteListing.stubs(:find_all_listings_favored_by).with(@listing.id, {:access_token => nil, :access_secret => nil}).returns(@favorite_listings)
#           User.stubs(:find).with([1, 2], {:access_token => nil, :access_secret => nil}).returns(['users'])
#           @listing.admirers({:access_token => nil, :access_secret => nil})).to eql(['users']
#         end
#       end
#   end
# end
