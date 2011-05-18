require 'spree_core'
require 'core_charges_hooks'

module SpreeCoreCharges
  class Engine < Rails::Engine
  
    def self.activate
      Adjustment.class_eval do 
        scope :core, lambda { where('label like ?',"#{I18n.t(:core_charge)}%") }
      end
      
      LineItem.class_eval do
        
        def update_adjustment(adjustment, source)
          adjustment.amount = if adjustment.order.line_items.include? source
            calculate_core_charge
          else
            0
          end
        end
        
        def calculate_core_charge
          return unless product.core_amount
          
          self.quantity * product.core_amount
        end
        
      end
      
      Order.register_update_hook('create_core_charges')
      
      Order.class_eval do

        has_many :core_charges,
                 :dependent => :destroy,
                 :class_name => 'Adjustment',
                 :conditions => "source_type='LineItem'"
        
      private
      
        def create_core_charges
          line_items(true).collect{|item| item if item.variant.product.core_amount }.compact.each do |item|
            adjustments << Adjustment.create({
                :label => I18n.t(:core_charge) + " [#{item.variant.sku || item.variant.name}]",
                :source => item,
                :order => self,
                :originator => item,
                :amount => item.calculate_core_charge
            }) unless core_charges.find(:first, :conditions => {:source_id => item.id})
          end
        end
        
      end
            
    end
    
    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare &method(:activate).to_proc
  end
end
