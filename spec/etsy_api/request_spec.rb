# RSpec.describe EtsyApi::Request do
#
#   describe EtsyApi::Request do
#
#     before(:each) do
#       EtsyApi.api_key = ENV['ETSY_API_KEY']
#       EtsyApi.access_token = ENV['ETSY_ACCESS_TOKEN']
#       EtsyApi.access_secret = ENV['ETSY_ACCESS_SECRET']
#       EtsyApi.api_secret = ENV['ETSY_API_SECRET']
#     end
#
#     it "gets a user object by login_name" do
#       response = EtsyApi::Request.get_user('timothyf')
#       expect(response).not_to eql(nil)
#       result = response.result
#       expect(result).not_to eql(nil)
#       expect(result['user_id']).to eql(7864556)
#       expect(result['login_name']).to eql('timothyf')
#     end
#
#     it "gets a user object by user_id" do
#       response = EtsyApi::Request.get_user('7864556')
#       expect(response).not_to eql(nil)
#       result = response.result
#       expect(result).not_to eql(nil)
#       expect(result['user_id']).to eql(7864556)
#       expect(result['login_name']).to eql('timothyf')
#     end
#
#     it "gets a user by user_id using the get method" do
#       response = EtsyApi::Request.get('/users/7864556')
#       expect(response).not_to eql(nil)
#       result = response.result
#       puts result.to_s
#       expect(result).not_to eql(nil)
#       expect(result['user_id']).to eql(7864556)
#       expect(result['login_name']).to eql('timothyf')
#     end
#
#     it "gets a shop by shop_id using the get method" do
#       response = EtsyApi::Request.get('/shops/20343394')
#       expect(response).not_to eql(nil)
#       result = response.result
#       puts result.to_s
#       expect(result).not_to eql(nil)
#       expect(result['shop_id']).to eql(20343394)
#       expect(result['shop_name']).to eql('TheHorrorWorkshop')
#     end
#
#   end
#
# end
