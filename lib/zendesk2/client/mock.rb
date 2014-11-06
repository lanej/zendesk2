class Zendesk2::Client < Cistern::Service
  class Mock
    include Shared

    attr_reader :username, :url, :token, :jwt_token

    def self.data
      @data ||= {
        :categories             => {},
        :forums                 => {},
        :groups                 => {},
        :help_center_articles   => {},
        :help_center_categories => {},
        :help_center_sections   => {},
        :identities             => {},
        :memberships            => {},
        :organizations          => {},
        :ticket_audits          => {},
        :ticket_comments        => {},
        :ticket_fields          => {},
        :ticket_metrics         => {},
        :tickets                => {},
        :topic_comments         => {},
        :topics                 => {},
        :user_fields            => {},
        :users                  => {},
      }
    end

    def self.new_id
      @current_id ||= 0
      @current_id += 1
      @current_id.to_s
    end

    def data
      self.class.data
    end

    def self.reset!
      @data = nil
    end

    def initialize(options={})
      @url                 = options[:url]
      @path                = Addressable::URI.parse(url).path
      @username, @password = options[:username], options[:password]
      @token               = options[:token]
      @jwt_token           = options[:jwt_token]

      @current_user ||= self.create_user("email" => @username, "name" => "Mock Agent").body["user"]
      @current_user_identity ||= self.data[:identities].values.first
    end

    # Lazily re-seeds data after reset
    # @return [Hash] current user response
    def current_user
      self.data[:users][@current_user["id"]] ||= @current_user
      self.data[:identities][@current_user_identity["id"]] ||= @current_user_identity

      @current_user
    end

    def html_url_for(path)
      File.join(@url, path.to_s)
    end

    def url_for(path)
      File.join(@url, "/api/v2", path.to_s)
    end

    def resources(collection, path, collection_root, options={})
      filter    = options[:filter]
      resources = self.data[collection].values
      resources = filter.call(resources) if filter
      count     = resources.size

      response(
        :body => {
          collection_root => resources,
          "count"         => count,
        },
        :path => path
      )
    end

    def page(params, collection, path, collection_root, options={})
      page_params = Zendesk2.paging_parameters(params)
      page_size   = (page_params["per_page"] || 50).to_i
      page_index  = (page_params["page"] || 1).to_i
      offset      = (page_index - 1) * page_size
      filter      = options[:filter]
      resources   = options[:resources] || self.data[collection].values
      resources   = filter.call(resources) if filter
      count       = resources.size
      total_pages = (count / page_size) + 1

      next_page = if page_index < total_pages
                    url_for("#{path}?page=#{page_index + 1}&per_page=#{page_size}")
                  end
      previous_page = if page_index > 1
                        url_for("#{path}?page=#{page_index - 1}&per_page=#{page_size}")
                      end

      resource_page = resources.slice(offset, page_size)

      body = {
        collection_root => resource_page,
        "count"         => count,
        "next_page"     => next_page,
        "previous_page" => previous_page,
      }

      response(
        :body => body,
        :path => path
      )
    end

    def pluralize(word)
      pluralized = word.dup
      [[/y$/, 'ies'], [/$/, 's']].find{|regex, replace| pluralized.gsub!(regex, replace) if pluralized.match(regex)}
      pluralized
    end

    def self.error_map
      @@error_map ||= {
        :invalid => [422, {
          "error"       => "RecordInvalid",
          "description" => "Record validation errors",
        }],
        :not_found => [404, {
          "error"       => "RecordNotFound",
          "description" => "Not found",
        }],
      }
    end

    def find!(collection, identity, options={})
      if resource = self.data[collection][identity.to_s]
        resource
      else
        error!(options[:error] || :not_found)
      end
    end

    def delete!(collection, identity, options={})
      self.data[collection].delete(identity.to_s) ||
        error!(options[:error] || :not_found)
    end

    def error!(type, options={})
      status, body = self.class.error_map[type]
      body.merge!("details" => options[:details]) if options[:details]

      response(
        :status => status,
        :body   => body,
      )
    end

    def response(options={})
      method = options[:method] || :get
      status = options[:status] || 200
      path   = options[:path]
      body   = options[:body]

      url = options[:url] || url_for(path)

      env = Faraday::Env.new(method, body, url, nil, {}, nil, nil, {}, nil, {"Content-Type"  => "application/json; charset=utf-8"}, status)

      Faraday::Response::RaiseError.new.on_complete(env) || Faraday::Response.new(env)
    rescue Faraday::Error::ClientError => e
      raise Zendesk2::Error.new(e)
    end
  end
end
