class Zendesk2::Client::Account < Cistern::Model
  identity :id
  attribute :active
  attribute :name

  def save
    if new_record?
      requires :name
      data = connection.create_account(attributes).body["account"]
      merge_attributes(data)
    else
      requires :identity
      params = {
        "id" => self.identity,
        "name" => self.name,
      }
      data = connection.update_account(params).body["account"]
      merge_attributes(data)
    end
  end

  def destroy
    requires :identity
    #raise "don't nuke yourself" if self.email == connection.accountname

    data = connection.destroy_account("id" => self.identity).body["account"]
    merge_attributes(data)
  end

  def destroyed?
    !self.active
  end
end
