module Spree
  module CoreCharges
    class Engine < Rails::Engine
      isolate_namespace Spree
      engine_name 'spree_core_charges'
  
      def self.activate
        Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end

        Spree::Order.register_update_hook(:create_core_charges)
      end
      
      config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/overrides)
      config.to_prepare &method(:activate).to_proc
    end
  end
end
