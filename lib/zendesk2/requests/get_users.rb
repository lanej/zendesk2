class Zendesk2::Client
  class Real
    def get_users(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/users.json",
      )
    end
  end
  class Mock
    def get_users(params={})
      page_params = Zendesk2.paging_parameters(params)

      page_size   = (page_params["per_page"] || 50).to_i
      page_index  = (page_params["page"] || 1).to_i
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
