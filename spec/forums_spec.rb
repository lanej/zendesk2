require 'spec_helper'

describe "forums" do
  let(:client) { create_client }

  include_examples "zendesk#resource", {
    :collection      => lambda { client.forums },
    :create_params   => lambda { { name: mock_uuid } },
    :update_params   => lambda { { name: mock_uuid } },
    :delayed_destroy => true,
  }

  context "#create_forum" do
    it "should correctly respond" do
      body = { "forum" => {"name" => (name = mock_uuid)} }

      response = client.create_forum(body)

      expect(response.status).to eq(201)
      expect(response.env[:url].path).to eq("/api/v2/forums.json")
      expect(response.env[:method]).to eq(:post)
      expect(client.last_request).to match(body)
      expect(response.env[:body]["forum"]).to match(
        a_hash_including(
          "name" => name,
        ))
    end
  end

  context "with a forum" do
    let!(:forum) { client.forums.create!(name: mock_uuid) }

    context "#destroy_forum" do
      it "should require a valid forum" do
        expect {
          client.destroy_forum(
            "forum" => {
              "id" => 999999999,
            }
          )
        }.to raise_error(Zendesk2::Error) { |e|
          expect(e.response[:status]).to eq(404)
        }
      end

      it "should correctly respond" do
        response = client.destroy_forum(
          "forum" => {
            "id" => forum.id,
          }
        )

        expect(response.status).to eq(200)
        expect(response.env[:url].path).to eq("/api/v2/forums/#{forum.id}.json")
        expect(response.env[:method]).to eq(:delete)
        expect(client.last_request).to eq(nil)
        expect(response.env[:body]).to be_falsey
      end
    end

    context "#get_forums" do
      it "should correctly respond" do
        response = client.get_forums

        expect(response.status).to eq(200)
        expect(response.env[:url].path).to eq("/api/v2/forums.json")
        expect(response.env[:method]).to eq(:get)
        expect(client.last_request).to eq(nil)
        skip unless Zendesk2.mocking?
        expect(response.env[:body]["forums"]).to match([
          a_hash_including(
            "id"   => forum.id,
          )])
      end
    end

    context "#get_forum" do
      it "should require a valid forum" do
        expect {
          client.get_forum(
            "forum" => {
              "id" => 999999999,
            }
          )
        }.to raise_error(Zendesk2::Error) { |e|
          expect(e.response[:status]).to eq(404)
        }
      end

      it "should correctly respond" do
        response = client.get_forum(
          "forum" => {
            "id" => forum.id,
          }
        )

        expect(response.status).to eq(200)
        expect(response.env[:url].path).to eq("/api/v2/forums/#{forum.id}.json")
        expect(response.env[:method]).to eq(:get)
        expect(client.last_request).to eq(nil)
        expect(response.env[:body]["forum"]).to match(
          a_hash_including(
            "id"   => forum.id,
            "url"  => response.env[:url].to_s,
          ))
      end
    end

    context "#update_forum" do
      it "should require a valid forum" do
        expect {
          client.update_forum(
            "forum" => {
              "id"   => 999999999,
              "name" => mock_uuid,
            }
          )
        }.to raise_error(Zendesk2::Error) { |e|
          expect(e.response[:status]).to eq(404)
        }
      end

      it "should correctly respond" do
        response = client.update_forum(
          "forum" => {
            "id"   => forum.id,
            "name" => (name = mock_uuid),
          }
        )

        expect(response.status).to eq(200)
        expect(response.env[:url].path).to eq("/api/v2/forums/#{forum.id}.json")
        expect(response.env[:method]).to eq(:put)
        expect(client.last_request).to eq("forum" => {"name" => name})
        expect(response.env[:body]["forum"]).to match(
          a_hash_including(
            "id"   => forum.id,
            "url"  => response.env[:url].to_s,
            "name" => name,
          ))
      end
    end
  end
end
