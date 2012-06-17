class Zendesk2::Client
  class Real
    def get_users(params={})
      query = if url = params["url"]
                uri = Addressable::URI.parse(url)
                uri.query_values
              else
                Cistern::Hash.slice(params, "page", "per_page")
              end

      request(
        :params  => query,
        :method  => :get,
        :path    => "/users.json",
      )
    end
  end
  class Mock
    def get_users(params={})
      page_params = if url = params.delete("url")
                      uri = Addressable::URI.parse(url)
                      uri.query_values
                    else
                      Cistern::Hash.slice(params, "page", "per_page")
                    end
      params.merge!(page_params)

      page_size   = (params["per_page"] || 50).to_i
      page_index  = (params["page"] || 1).to_i
      count       = self.data[:users].size
      offset      = (page_index - 1) * page_size
      total_pages = (count / page_size) + 1


      next_page = if page_index < total_pages
                    File.join(@url, "users.json?page=#{page_index + 1}&per_page=#{page_size}")
                  else
                    nil
                  end
      previous_page = if page_index > 1
                        File.join(@url, "users.json?page=#{page_index - 1}&per_page=#{page_size}")
                      else
                        nil
                      end

      user_page = self.data[:users].values.slice(offset, page_size)

      body = {
        "users"         => user_page,
        "count"         => count,
        "next_page"     => next_page,
        "previous_page" => previous_page,
      }

      response(
        body: body,
        path: "/users.json"
      )
    end
  end
end
