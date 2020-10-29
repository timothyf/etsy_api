require 'etsy_api'
require 'active_support'

def raw_fixture_data(filename)
  file = File.dirname(__FILE__) + "/fixtures/#{filename}"
  File.read(file)
end

def read_fixture(filename)
  JSON.parse(raw_fixture_data(filename))['results']
end

def mock_request(endpoint, options, resource, file)
  objects       = []
  underscored_fixture_filename = "#{resource.gsub(/([^^])([A-Z])/, '\1_\2').downcase}/#{file}"
  response_data = raw_fixture_data(underscored_fixture_filename)


  expect(EtsyApi::Request.stub(:new)
          .with(endpoint, options)
          .and_return(EtsyApi::Request.stub(:get).and_return(EtsyApi::Response.new(stub(:body => response_data, :code => '200')))))

  JSON.parse(response_data)['results'].each_with_index do |result, index|
    object = "#{resource.downcase}_#{index}"
    if options[:access_token] && options[:access_secret]
      expect(EtsyApi.const_get(resource).stub(:new)
                .with(result, options[:access_token], options[:access_secret])
                .and_return(object))
    else
      expect(EtsyApi.const_get(resource).stub(:new)
                .with(result)
                .and_return(object))
    end
    objects << object
  end

  objects
end
