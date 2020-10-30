require 'spec_helper'
require 'dotenv/load'


describe EtsyApi::Transaction do

  before(:each) do
    EtsyApi.api_key = ENV['ETSY_API_KEY']
    EtsyApi.access_token = ENV['ETSY_ACCESS_TOKEN']
    EtsyApi.access_secret = ENV['ETSY_ACCESS_SECRET']
    EtsyApi.api_secret = ENV['ETSY_API_SECRET']
  end


  context "The Transaction class" do

    it "shoud be able to find transactions for a shop" do
      transactions = mock_request('/shops/1/transactions', {'key' => 'value'}, 'Transaction', 'findAllShopTransactions.json')
      expect(EtsyApi::Transaction.find_all_by_shop_id(1, {'key' => 'value'})).to eql(transactions)
    end

    it "shoud be able to find transactions for a buyer" do
      transactions = mock_request('/users/1/transactions', {'key' => 'value'}, 'Transaction', 'findAllShopTransactions.json')
      expect(EtsyApi::Transaction.find_all_by_buyer_id(1, {'key' => 'value'})).to eql(transactions)
    end

    it "shoud be able to find transactions for a receipt" do
      transactions = mock_request('/receipts/1/transactions', {'key' => 'value'}, 'Transaction', 'findAllShopTransactions.json')
      expect(EtsyApi::Transaction.find_all_by_receipt_id(1, {'key' => 'value'})).to eql(transactions)
    end
  end

  context "An instance of the Transaction class" do

    context "with response data" do
      before(:each) do
        data = read_fixture('transaction/findAllShopTransactions.json')
        @transaction = EtsyApi::Transaction.new(data.first)
      end

      it "should have a value for :id" do
        expect(@transaction.id).to eql(27230877)
      end

      it "should have a value for :quantity" do
        expect(@transaction.quantity).to eql(1)
      end

      it "should have a value for :buyer_id" do
        expect(@transaction.buyer_id).to eql(9641557)
      end

      it "should have a value for :listing_id" do
        expect(@transaction.listing_id).to eql(41680579)
      end
    end
  end

  it "should know the buyer" do
    EtsyApi::User.stub(:find).with(1, {}).and_return('user')

    transaction = EtsyApi::Transaction.new
    transaction.stub(:buyer_id).with(no_args).and_return(1)

    expect(transaction.buyer).to eql('user')
  end

end
