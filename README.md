# Zendesk2

[![Build Status](https://secure.travis-ci.org/lanej/zendesk2.png)](http://travis-ci.org/lanej/zendesk2)

Ruby client for the [Zendesk V2 API](http://developer.zendesk.com/documentation/rest_api/introduction.html) using [cistern](https://github.com/lanej/cistern) and [faraday](https://github.com/technoweenie/faraday)

## Installation

Add this line to your application's Gemfile:

    gem 'zendesk2'

Or install it yourself as:

    $ gem install zendesk2

## Usage

### Defaults

Default credentials (username, password, subdomain) will be read in from `~/.zendesk2` file if it exists.

### Creating the client

Either the absolute url or the subdomain is required.  Username and password is always required.

	Zendesk2::Client.new(subdomain: "engineyard", username: "orchestra", password: "gwoo")
	=> #<Zendesk2::Client::Real:0x007f99da1f9430 @url="https://engineyard.zendesk.com/api/v2", @username="orchestra", @password="gwoo", …>

or

	=> #<Zendesk2::Client::Real:0x007fd1bae486b0 @url="http://support.cloud.engineyard.com", @username="mate", @password="bambilla", …>

### Resources

Currently support resources

* Users
* Tickets
* Organizations

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
