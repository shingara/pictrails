# This patch is add for fix bug #4635 (http://dev.rubyonrails.org/ticket/4635)
# It's not integrate actually.
# For Integration test, there are no way to send File in multipart
# With this patch a multipart can be send
# Please made +1 in this patch. He works with pictrails

module ActionController
  module Integration
    class Session
      def multipart_post(url, parameters, headers = {})
        boundary = "----------XnJLe9ZIbbGUYtzPQJ16u1"
        post url, multipart_body(parameters, boundary), headers.merge({"CONTENT_TYPE" => "multipart/form-data; boundary=#{boundary}"})
      end
      
      def multipart_requestify(params, first=true)
        returning p = {} do
          params.each do |key, value|
            k = first ? CGI.escape(key.to_s) : "[#{CGI.escape(key.to_s)}]"
            if Hash === value
              multipart_requestify(value, false).each do |subkey, subvalue|
                p[k + subkey] = subvalue
              end
            else
              p[k] = value
            end
          end
        end
      end

      def multipart_body(params, boundary)
        multipart_requestify(params).map do |key, value|
          if value.respond_to?(:original_filename)
            File.open(value.path) do |f|
              <<-EOF
--#{boundary}\r
Content-Disposition: form-data; name="#{key}"; filename="#{CGI.escape(value.original_filename)}"\r
Content-Type: #{value.content_type}\r
Content-Length: #{File.stat(value.path).size}\r
\r
#{f.read}\r
EOF
            end
          else
            <<-EOF
--#{boundary}\r
Content-Disposition: form-data; name="#{key}"\r
\r
#{value}\r
EOF
          end
        end.join("")+"--#{boundary}--\r"
      end
    end
  end
end

