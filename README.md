# Zendesk2

[![Build Status](https://travis-ci.org/lanej/zendesk2.svg?branch=master)](http://travis-ci.org/lanej/zendesk2)
[![Gem Version](https://fury-badge.herokuapp.com/rb/zendesk2.png)](http://badge.fury.io/rb/zendesk2)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/lanej/zendesk2)
[![Dependency Status](https://gemnasium.com/lanej/zendesk2.png)](https://gemnasium.com/lanej/zendesk2)

Ruby client for the [Zendesk V2 API](http://developer.zendesk.com/documentation/rest_api/introduction.html) using [cistern](https://github.com/lanej/cistern) and [faraday](https://github.com/technoweenie/faraday).  Ruby > 2.0 is required

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'zendesk2'
```
Or install it yourself as:

    $ gem install zendesk2

## Usage

### Mock it!

All support resources have basic mocks.  Error conditions and messaging are constantly changing. Please contribute updates or fixes to the mock if you encounter inconsistencies.

```ruby
Zendesk2.mock!

client = Zendesk2.new(...) # Zendesk2::Mock
client.organizations.create!(name: "foo") # Zendesk2::Organization
client.organizations.create!(name: "foo") # Zendesk2::Error => Name has already been taken
```

### Defaults

Default credentials will be read in from `~/.zendesk2` file in YAML format.

```yaml
---
:url: https://www.zendesk.com
:username: zendeskedge@example.com
:password: wickedsecurepassword
:token: reallylongrandomstringprovidedbyzendesk
```

### Creating the client

Url is always required. Username and either password or token are always required.

```ruby
Zendesk2.new(url: "http://support.cloud.engineyard.com", username: "mate", token: "asdfghjkl1qwertyuiop5zxcvbnm3")
=> #<Zendesk2::Real:0x007fd1bae486b0 @url="http://support.cloud.engineyard.com", @username="mate", @token="asdfghjkl1qwertyuiop5zxcvbnm3", …>
```

### Resources

#### Collections

Currently support resources:

* Audit Events
* Brands
* Categories
* Forums
* Groups
* Memberships
* Organization
* Ticket Audits
* Ticket Fields
* Tickets
* Ticket Forms
* Topic Comments
* Topics
* User Identities
* User Fields
* Users
* Views

Help Center resources:

* Sections
* Articles
* Categories

All collection are accessed like so:

```ruby
client.users.all
=> <Zendesk2::Users
  count=1779,
  next_page_link="https://dev.zendesk.com/api/v2/users.json?page=2",
  previous_page_link=nil
  [
    <Zendesk2::User
      id=125394183,
      url="https://dev.zendesk.com/api/v2/users/125394183.json",
      ...
    >
  ]
```

Collections also respond to `create` and `new`

```ruby
client.users.create(email: "ohhai@example.org", name: "lulz")
=> <Zendesk2::User
  id=234020811,
  ...
  url="https://engineyarddev.zendesk.com/api/v2/users/234020811.json",
  ...
  email="ohhai@example.org",
  >
```

```ruby
client.users.new(email: "ohhai@example.org")
=> <Zendesk2::User
  id=nil,
  ...
  url=nil,
  ...
  email="ohhai@example.org",
  ...
  >
```

#### Paging

Paged collections respond to `next_page` and `previous_page` when appropriate.  `page_size` and `page` can be passed directly to the collection to control size and index.

```ruby
page = client.users.all("per_page" => 1, "page" => 4)
=> <Zendesk2::Users
  count=1780,
  next_page_link="https://dev.zendesk.com/api/v2/users.json?page=5&per_page=1",
  previous_page_link="https://dev.zendesk.com/api/v2/users.json?page=3&per_page=1"
  [
    <Zendesk2::User
      id=217761652,
      url="https://dev.zendesk.com/api/v2/users/217761652.json",
      external_id=nil,
      name="Guy Dude",
      ...
    >
  ]
```

```ruby
page.next_page
=> <Zendesk2::Users
  count=1780,
  next_page_link="https://dev.zendesk.com/api/v2/users.json?page=6&per_page=1",
  previous_page_link="https://dev.zendesk.com/api/v2/users.json?page=4&per_page=1"
  [
    <Zendesk2::User
      id=217761742,
      url="https://dev.zendesk.com/api/v2/users/217761742.json",
      ...
      name="epitaphical osteofibrous",
      ...
    >
  ]
```

```ruby
page.previous_page
=> <Zendesk2::Users
  count=1780,
  next_page_link="https://dev.zendesk.com/api/v2/users.json?page=5&per_page=1",
  previous_page_link="https://dev.zendesk.com/api/v2/users.json?page=3&per_page=1"
  [
    <Zendesk2::User
      id=217761652,
      url="https://dev.zendesk.com/api/v2/users/217761652.json",
      ...
      name="Guy Dude",
      ...
    >
  ]
```

#### Models

All models respond to `destroy` and `save` if applicable.  `save` performs a 'create' operation if there is no identity provided or an 'update' if there is an identity.

```ruby
Zendesk2::Ticket.new.save        # performs a create
Zendesk2::Ticket.new(id: 1).save # performs an update
```

Attributes can be enumerated by the `attributes` method.

## Testing
### Running

    $ bundle exec rspec

### Testing Live

Run against a real Zendesk installation by setting ```MOCK_ZENDESK=false```

    $ MOCK_ZENDESK=false bundle exec rspec

Credentials are sourced from your ```~/.zendesk2``` file

Raw responses and requests can be echoed to STDOUT by adding ```VERBOSE=true```

    $ VERBOSE=true bundle exec rspec

## Releasing

    $ gem install gem-release
    $ gem bump -trv (major|minor|patch)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
