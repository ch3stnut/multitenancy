module Subscribem
  module Constraints
    module SubdomainRequired
      def self.matches?(request)
        request.subdomain.present? && request.subdomain != "www"
      end
    end
  end
end