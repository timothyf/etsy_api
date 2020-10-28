require 'spec_helper'


describe EtsyApi::User do

   context "The User class" do
    before(:each) do

    end

    it "should be able to find a single user" do
      users = mock_request('/users/littletjane', {:access_secret=>nil, :access_token=>nil, :api_key=>nil}, 'User', 'getUser.single.json')
      # users = [{
      #     "count": 1,
      #     "results": [{
      #         "user_id": 5327518,
      #         "login_name": "littletjane",
      #         "creation_tsz": 1191381578,
      #         "referred_by_user_id": nil,
      #         "feedback_info": {
      #             "count": 417,
      #             "score": 100
      #         }
      #     }]
      # }]
      expect(EtsyApi::User.find('littletjane')).to eql(users.first)
    end

    it "should be able to find multiple users" do
      users = mock_request('/users/littletjane,reagent', {}, 'User', 'getUser.multiple.json')
      expect(EtsyApi::User.find('littletjane', 'reagent')).to eql(users)
    end

    it "should be able to pass options when finding a user" do
      options = {:limit => 90, :offset => 90}
      users = mock_request('/users/littletjane', options, 'User', 'getUser.single.json')
      expect(EtsyApi::User.find('littletjane', options)).to eql(users.first)
    end

    it "should be able to find the authenticated user" do
      options = {:access_token => 'token', :access_secret => 'secret'}
      users = mock_request('/users/__SELF__', options, 'User', 'getUser.single.json')
      expect(EtsyApi::User.myself('token', 'secret', options)).to eql(users.first)
    end
  end


  context "An instance of the User class" do

    context "requested with oauth access token" do
      before(:each) do
        options = {:access_token => 'token', :access_secret => 'secret'}

        data = read_fixture('user/getUser.single.json')
        response = 'response'
        expect(response.stub(:result).with(no_args).and_return([data]))
        expect(EtsyApi::Request.stub(:get).with('/users/__SELF__', options).and_return(response))

        @user = EtsyApi::User.find('__SELF__', options)
      end

      it "should persist the token" do
        expect(@user.token).to eql('token')
      end

      it "should persist the secret" do
        expect(@user.secret).to eql('secret')
      end
    end


  end

end

# RSpec.describe EtsyApi do
#   it "has a version number" do
#     expect(EtsyApi::VERSION).not_to be nil
#   end
# end
#
# module Etsy
#   class UserTest < Test::Unit::TestCase
#
#
#     context "An instance of the User class" do
#
#       context "with public response data" do
#         setup do
#           data = read_fixture('user/getUser.single.json')
#           @user = User.new(data.first)
#         end
#
#         should "have an ID" do
#           @user.id.should == 5327518
#         end
#
#         should "have a :username" do
#           @user.username.should == 'littletjane'
#         end
#
#         should "have a value for :created" do
#           @user.created.should == 1191381578
#         end
#
#         should "not have an email address" do
#           @user.email.should be_nil
#         end
#       end
#
#       context "with private response data" do
#         setup do
#           data = read_fixture('user/getUser.single.private.json')
#           @user = User.new(data.first, 'token', 'secret')
#         end
#
#         should "have an email address" do
#           @user.email.should == 'reaganpr@gmail.com'
#         end
#       end
#
#       context "requested with associated shops" do
#         setup do
#           data = read_fixture('user/getUser.single.withShops.json')
#           @user = User.new(data.first)
#         end
#
#         should "have shops" do
#           @user.shops.each do |shop|
#             shop.class.should == Shop
#           end
#         end
#
#         # This assumes for now that a user can have only one shop belonging to them
#         should "return the first shop belonging to the user" do
#           @user.shop.should == @user.shops.first
#         end
#       end
#
#       context "requested without associated shops" do
#         setup do
#           @data_without_shops = read_fixture('user/getUser.single.json')
#           @data_with_shops = read_fixture('user/getUser.single.withShops.json')
#           @options = {:fields => 'user_id', :includes => 'Shops'}
#
#           @user_without_shops = User.new(@data_without_shops.first)
#           @user_with_shops = User.new(@data_with_shops.first)
#         end
#
#         should "make a call to the API to retrieve it if requested" do
#           User.expects(:find).with('littletjane', @options).returns @user_with_shops
#           @user_without_shops.shops
#         end
#
#         should "not call the api twice" do
#           User.expects(:find).once.with('littletjane', @options).returns @user_with_shops
#           @user_without_shops.shops
#           @user_without_shops.shops
#         end
#
#         should "return a list of populated shop instances" do
#           User.stubs(:find).with('littletjane', @options).returns @user_with_shops
#           @user_without_shops.shops.first.name.should == 'LittleJane'
#         end
#
#         should "make the call with authentication if oauth is used" do
#           user = User.new(@data_without_shops.first, 'token', 'secret')
#           oauth = {:access_token => 'token', :access_secret => 'secret'}
#           User.expects(:find).with('littletjane', @options.merge(oauth)).returns @user_with_shops
#           user.shops
#         end
#       end
#
#       context "requested with an associated profile" do
#         setup do
#           data = read_fixture('user/getUser.single.withProfile.json')
#           @user = User.new(data.first)
#         end
#
#         should "have a profile" do
#           @user.profile.class.should == Profile
#         end
#       end
#
#       context "requested without an associated profile" do
#         setup do
#           @data_without_profile = read_fixture('user/getUser.single.json')
#           @data_with_profile = read_fixture('user/getUser.single.withProfile.json')
#           @options = {:fields => 'user_id', :includes => 'Profile'}
#
#           @user_without_profile = User.new(@data_without_profile.first)
#           @user_with_profile = User.new(@data_with_profile.first)
#         end
#
#         should "make a call to the API to retrieve it if requested" do
#           User.expects(:find).with('littletjane', @options).returns @user_with_profile
#           @user_without_profile.profile
#         end
#
#         should "not call the api twice" do
#           User.expects(:find).once.with('littletjane', @options).returns @user_with_profile
#           @user_without_profile.profile
#           @user_without_profile.profile
#         end
#
#         should "return a populated profile instance" do
#           User.stubs(:find).with('littletjane', @options).returns @user_with_profile
#           @user_without_profile.profile.bio.should == 'I make stuff'
#         end
#
#         should "make the call with authentication if oauth is used" do
#           user = User.new(@data_without_profile.first, 'token', 'secret')
#           oauth = {:access_token => 'token', :access_secret => 'secret'}
#           User.expects(:find).with('littletjane', @options.merge(oauth)).returns @user_with_profile
#           user.profile
#         end
#       end
#
#       context "instantiated with oauth token" do
#         setup do
#           @user = User.new(nil, 'token', 'secret')
#         end
#
#         should "have the token" do
#           @user.token.should == 'token'
#         end
#
#         should "have the secret" do
#           @user.secret.should == 'secret'
#         end
#
#       end
#
#       should "know when the user was created" do
#         user = User.new
#         user.stubs(:created).returns(1)
#
#         user.created_at.should == Time.at(1)
#       end
#
#       context "with favorite listings data" do
#         setup do
#           data = read_fixture('user/getUser.single.withProfile.json')
#           @user = User.new(data.first)
#           listing_1 = stub(:listing_id => 1, :user_id => @user.id)
#           listing_2 = stub(:listing_id => 2, :user_id => @user.id)
#           @favorite_listings = [listing_1, listing_2]
#         end
#
#         should "have all listings" do
#           FavoriteListing.stubs(:find_all_user_favorite_listings).with(@user.id, {:access_token => nil, :access_secret => nil}).returns(@favorite_listings)
#           Listing.stubs(:find).with([1, 2], {:access_token => nil, :access_secret => nil}).returns(['listings'])
#           @user.favorites.should == ['listings']
#         end
#       end
#
#       context "with bought listings data" do
#         setup do
#           data = read_fixture('user/getUser.single.withProfile.json')
#           @user = User.new(data.first)
#           listing_1 = stub(:listing_id => 1, :user_id => @user.id)
#           listing_2 = stub(:listing_id => 2, :user_id => @user.id)
#           @bought_listings = [listing_1, listing_2]
#         end
#
#         should "have all listings" do
#           Transaction.stubs(:find_all_by_buyer_id).with(@user.id, {:access_token => nil, :access_secret => nil}).returns(@bought_listings)
#           Listing.stubs(:find).with([1, 2], {:access_token => nil, :access_secret => nil}).returns(['listings'])
#           @user.bought_listings.should == ['listings']
#         end
#       end
#     end
#
#     should "know the addresses for a user" do
#       user = User.new
#       user.stubs(:username).with().returns('username')
#
#       Address.stubs(:find).with('username', {}).returns('addresses')
#
#       user.addresses.should == 'addresses'
#     end
#
#   end
# end
