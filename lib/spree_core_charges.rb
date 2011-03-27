require 'spree_core'
require 'core_charges_hooks'

module SpreeCoreCharges
  class Engine < Rails::Engine
  
    def self.activate
#      Dir.glob(File.join(File.dirname(__FILE__), "../app/models/*.rb")) do |c|
#        Rails.env.production? ? require(c) : load(c)
#      end
      
      Adjustment.class_eval do 
        scope :core, lambda { where('label like ?',"#{I18n.t(:core_charge)}%") }
      end
      
      Order.class_eval do
        #has_many :core_charges
        before_save :update_core_charges
        
      private
      
        def update_core_charges
          line_items.collect{|item| item if item.variant.product.core_amount }.compact.each do |item|
            adjustments << CoreCharge.create({
                :label => I18n.t(:core_charge) + " [#{item.variant.sku || item.variant.name}]",
                :source => item,
                :order => self
            }) unless adjustments.find(:first, :conditions => {:source_id => item.id})
          end
        end
        
      end
            
    end
    
    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare &method(:activate).to_proc
  end
end
