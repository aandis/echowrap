
require 'helper'

describe Echonest::Client do

  subject do
    Echonest::Client.new(:api_key => "AK", :consumer_key => "CK", :shared_secret => "SS")
  end

  context "with module configuration" do

    before do
      Echonest.configure do |config|
        Echonest::Configurable.keys.each do |key|
          config.send("#{key}=", key)
        end
      end
    end

    after do
      Echonest.reset!
    end

    it "inherits the module configuration" do
      client = Echonest::Client.new
      Echonest::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq key
      end
    end

    context "with class configuration" do

      before do
        @configuration = {
          :connection_options => {:timeout => 10},
          :api_key => 'AK',
          :consumer_key => 'CK',
          :shared_secret => 'SS',
          :endpoint => 'http://tumblr.com/',
          :middleware => Proc.new{}
        }
      end

      context "during initialization" do
        it "overrides the module configuration" do
          client = Echonest::Client.new(@configuration)
          Echonest::Configurable.keys.each do |key|
            expect(client.instance_variable_get(:"@#{key}")).to eq @configuration[key]
          end
        end
      end

      context "after initialization" do
        it "overrides the module configuration after initialization" do
          client = Echonest::Client.new
          client.configure do |config|
            @configuration.each do |key, value|
              config.send("#{key}=", value)
            end
          end
          Echonest::Configurable.keys.each do |key|
            expect(client.instance_variable_get(:"@#{key}")).to eq @configuration[key]
          end
        end
      end

    end
  end

  # it "does not cache the screen name across clients" do
  #   stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
  #   client1 = Echonest::Client.new
  #   expect(client1.verify_credentials.id).to eq 7505382
  #   stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("pengwynn.json"), :headers => {:content_type => "application/json; charset=utf-8"})
  #   client2 = Echonest::Client.new
  #   expect(client2.verify_credentials.id).to eq 14100886
  # end
  #
  # describe "#delete" do
  #   before do
  #     stub_delete("/custom/delete").with(:query => {:deleted => "object"})
  #   end
  #   it "allows custom delete requests" do
  #     subject.delete("/custom/delete", {:deleted => "object"})
  #     expect(a_delete("/custom/delete").with(:query => {:deleted => "object"})).to have_been_made
  #   end
  # end
  #
  # describe "#put" do
  #   before do
  #     stub_put("/custom/put").with(:body => {:updated => "object"})
  #   end
  #   it "allows custom put requests" do
  #     subject.put("/custom/put", {:updated => "object"})
  #     expect(a_put("/custom/put").with(:body => {:updated => "object"})).to have_been_made
  #   end
  # end
  #
  # describe "#credentials?" do
  #   it "returns true if all credentials are present" do
  #     client = Echonest::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
  #     expect(client.credentials?).to be_true
  #   end
  #   it "returns false if any credentials are missing" do
  #     client = Echonest::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT')
  #     expect(client.credentials?).to be_false
  #   end
  # end
  #
  describe "#connection" do
    it "looks like Faraday connection" do
      expect(subject.send(:connection)).to respond_to(:run_request)
    end
    it "memoizes the connection" do
      c1, c2 = subject.send(:connection), subject.send(:connection)
      expect(c1.object_id).to eq c2.object_id
    end
  end

  # describe "#request" do
  #   it "encodes the entire body when no uploaded media is present" do
  #     stub_post("/1.1/statuses/update.json").with(:body => {:status => "Update"}).to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
  #     subject.update("Update")
  #     expect(a_post("/1.1/statuses/update.json").with(:body => {:status => "Update"})).to have_been_made
  #   end
  #   it "encodes none of the body when uploaded media is present" do
  #     stub_post("/1.1/statuses/update_with_media.json")
  #     subject.update_with_media("Update", fixture("pbjt.gif"))
  #     expect(a_post("/1.1/statuses/update_with_media.json")).to have_been_made
  #   end
  #   it "catches Faraday errors" do
  #     subject.stub!(:connection).and_raise(Faraday::Error::ClientError.new("Oops"))
  #     expect{subject.send(:request, :get, "/path")}.to raise_error Echonest::Error::ClientError
  #   end
  #   it "catches MultiJson::DecodeError errors" do
  #     subject.stub!(:connection).and_raise(MultiJson::DecodeError.new("unexpected token", [], "<!DOCTYPE html>"))
  #     expect{subject.send(:request, :get, "/path")}.to raise_error Echonest::Error::DecodeError
  #   end
  # end

  # describe "#oauth_auth_header" do
  #   it "creates the correct auth headers" do
  #     uri = "/1.1/direct_messages.json"
  #     authorization = subject.send(:oauth_auth_header, :get, uri)
  #     expect(authorization.options[:signature_method]).to eq "HMAC-SHA1"
  #     expect(authorization.options[:version]).to eq "1.0"
  #     expect(authorization.options[:consumer_key]).to eq "CK"
  #     expect(authorization.options[:consumer_secret]).to eq "CS"
  #     expect(authorization.options[:token]).to eq "OT"
  #     expect(authorization.options[:token_secret]).to eq "OS"
  #   end
  # end
  #
  # describe "#bearer_auth_header" do
  #   subject do
  #     Echonest::Client.new(:bearer_token => "BT")
  #   end
  #
  #   it "creates the correct auth headers with supplied bearer_token" do
  #     uri = "/1.1/direct_messages.json"
  #     authorization = subject.send(:bearer_auth_header)
  #     expect(authorization).to eq "Bearer BT"
  #   end
  # end
  #
  # describe "#bearer_token_credentials_auth_header" do
  #   it "creates the correct auth header with supplied consumer_key and consumer_secret" do
  #     uri = "/1.1/direct_messages.json"
  #     authorization = subject.send(:bearer_token_credentials_auth_header)
  #     expect(authorization).to eq "Basic #{Base64.strict_encode64("CK:CS")}"
  #   end
  # end
end

