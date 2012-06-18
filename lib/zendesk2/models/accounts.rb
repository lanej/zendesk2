class Zendesk2::Client::Accounts < Cistern::Collection
  include Zendesk2::PagedCollection

  model Zendesk2::Client::Account

  self.collection_method= :get_accounts
  self.collection_root= "accounts"
  self.model_method= :get_account
  self.model_root= "account"

  def search(term)
    body = connection.search_account("query" => term).body
    if data = body.delete("results")
      load(data)
    end
    merge_attributes(body)
  end
end
