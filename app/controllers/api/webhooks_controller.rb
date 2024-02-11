module Api
  class WebhooksController < Api::ApplicationController
    skip_before_action :verify_authenticity_token
    def github
      puts "POLUCHENNO"

    end
  end

end
