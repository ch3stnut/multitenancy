module Subscribem
  class Engine < ::Rails::Engine
    isolate_namespace Subscribem
    
    require "warden"
    require "dynamic_form"

    config.generators do |g|
      g.test_framework :rspec, view_specs: false
    end

    initializer "subscribem.middleware.warden" do
      Rails.application.config.middleware.use Warden::Manager do |manager|
        manager.default_strategies :password
      end
    end
    
  end
end
