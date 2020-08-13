RSpec.describe EtsyApi do
  it "has a version number" do
    expect(EtsyApi::VERSION).not_to be nil
  end

  # it "does something useful" do
  #   expect(false).to eq(true)
  # end

  describe EtsyApi::Request do
    it "broccoli is gross" do
      expect(EtsyApi::Request.portray("Broccoli")).to eql("Gross!")
    end

    it "anything else is delicious" do
      expect(EtsyApi::Request.portray("Not Broccoli")).to eql("Delicious!")
    end
  end
end
