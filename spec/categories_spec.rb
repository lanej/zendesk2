require 'spec_helper'

describe "categories" do
  let(:client) { create_client }

  include_examples "zendesk#resource", {
    :collection    => lambda { client.categories },
    :create_params => lambda { { name: mock_uuid } },
    :update_params => lambda { { name: mock_uuid } },
  }

  context "#create_category" do
    it "should correctly respond" do
      body = { "category" => {"name" => (name = mock_uuid)} }

      response = client.create_category(body)

      expect(response.status).to eq(201)
      expect(response.env[:url].path).to eq("/api/v2/categories.json")
      expect(response.env[:method]).to eq(:post)
      expect(client.last_request).to match(body)
      expect(response.env[:body]["category"]).to match(
        a_hash_including(
          "name" => name,
        ))
    end
  end

  context "with a category" do
    let!(:category) { client.categories.create!(name: mock_uuid) }

    context "#destroy_category" do
      it "should require a valid category" do
        expect {
          client.destroy_category(
            "category" => {
              "id" => 999999999,
            }
          )
        }.to raise_error(Zendesk2::Error) { |e|
          expect(e.response[:status]).to eq(404)
        }
      end

      it "should correctly respond" do
        response = client.destroy_category(
          "category" => {
            "id" => category.id,
          }
        )

        expect(response.status).to eq(200)
        expect(response.env[:url].path).to eq("/api/v2/categories/#{category.id}.json")
        expect(response.env[:method]).to eq(:delete)
        expect(client.last_request).to eq(nil)
        expect(response.env[:body]).to be_falsey
      end
    end

    context "#get_categories" do
      it "should correctly respond" do
        response = client.get_categories

        expect(response.status).to eq(200)
        expect(response.env[:url].path).to eq("/api/v2/categories.json")
        expect(response.env[:method]).to eq(:get)
        expect(client.last_request).to eq(nil)
        skip unless Zendesk2.mocking?
        expect(response.env[:body]["categories"]).to match([
          a_hash_including(
            "id"   => category.id,
          )])
      end
    end

    context "#get_category" do
      it "should require a valid category" do
        expect {
          client.get_category(
            "category" => {
              "id" => 999999999,
            }
          )
        }.to raise_error(Zendesk2::Error) { |e|
          expect(e.response[:status]).to eq(404)
        }
      end

      it "should correctly respond" do
        response = client.get_category(
          "category" => {
            "id" => category.id,
          }
        )

        expect(response.status).to eq(200)
        expect(response.env[:url].path).to eq("/api/v2/categories/#{category.id}.json")
        expect(response.env[:method]).to eq(:get)
        expect(client.last_request).to eq(nil)
        expect(response.env[:body]["category"]).to match(
          a_hash_including(
            "id"   => category.id,
            "url"  => response.env[:url].to_s,
          ))
      end
    end

    context "#update_category" do
      it "should require a valid category" do
        expect {
          client.update_category(
            "category" => {
              "id"   => 999999999,
              "name" => mock_uuid,
            }
          )
        }.to raise_error(Zendesk2::Error) { |e|
          expect(e.response[:status]).to eq(404)
        }
      end

      it "should correctly respond" do
        response = client.update_category(
          "category" => {
            "id"   => category.id,
            "name" => (name = mock_uuid),
          }
        )

        expect(response.status).to eq(200)
        expect(response.env[:url].path).to eq("/api/v2/categories/#{category.id}.json")
        expect(response.env[:method]).to eq(:put)
        expect(client.last_request).to eq("category" => {"name" => name})
        expect(response.env[:body]["category"]).to match(
          a_hash_including(
            "id"   => category.id,
            "url"  => response.env[:url].to_s,
            "name" => name,
          ))
      end
    end
  end
end
