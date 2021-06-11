module Fog
  module Storage
    class GoogleJSON
      module Utils
        def http_url(params, expires)
          "http://" << host_path_query(params, expires)
        end

        def https_url(params, expires)
          "https://" << host_path_query(params, expires)
        end

        def url(params, expires)
          Fog::Logger.deprecation("Fog::Storage::Google => #url is deprecated, use #https_url instead [light_black](#{caller.first})[/]")
          https_url(params, expires)
        end

        private

        def host_path_query(params, expires)
          params[:headers]["Date"] = expires.to_i
          # implementation from CGI.escape, but without ' ' to  '+' conversion
          params[:path] = params[:path].b.gsub(/([^a-zA-Z0-9_.\-~]+)/) { |m|
            '%' + m.unpack('H2' * m.bytesize).join('%').upcase
          }.gsub("%2F", "/")

          query = []

          if params[:query]
            filtered = params[:query].reject { |k, v| k.nil? || v.nil? }
            query = filtered.map { |k, v| [k.to_s, Fog::Google.escape(v)].join("=") }
          end

          query << "GoogleAccessId=#{google_access_id}"
          query << "Signature=#{CGI.escape(signature(params))}"
          query << "Expires=#{params[:headers]['Date']}"
          "#{params[:host]}/#{params[:path]}?#{query.join('&')}"
        end
      end
    end
  end
end
