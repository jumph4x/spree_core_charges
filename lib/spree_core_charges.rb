require 'spree_core'
require 'core_charges_overrides'

module SpreeCoreCharges
  class Engine < Rails::Engine
  
    def self.activate
    
      Adjustment.class_eval do 
        scope :core, lambda { where('label like ?',"#{I18n.t(:core_charge)}%") }
      end
      
      LineItem.class_eval do
        
        def update_adjustment(adjustment, source)
          adjustment.amount = if adjustment.order(true).line_items.include? source
            calculate_core_charge
          else
            0
          end
          
          adjustment.save
        end
        
        def calculate_core_charge
          return unless product.core_amount
          
          self.quantity * product.core_amount
        end
        
      private
        
        def create_core_charges
          order.core_charges << CoreCharge.create({
            :label =>  "#{I18n.t(:core_charge)} [#{variant.sku}]",
            :source => self,
            :order => order,
            :originator => self,
            :amount => calculate_core_charge
          }) unless order.core_charges.detect{|cc| cc.source_id == id}
        end
        
        def destroy_core_charges
          order.core_charges.select{|cc| cc.source_id == id}.map(&:destroy)
          
          order.update!
        end
        
        def update_core_charges
          return order.update! unless self.product.core_amount

          if self.destroyed?
            destroy_core_charges
          elsif 
            create_core_charges
          end
        end
      
        def update_order
          # update the order totals, etc.
          update_core_charges
          
          # implied in the above action
          #order.update!
        end
      
      end
      
      Order.class_eval do

        has_many :core_charges,
                 :dependent => :destroy,
                 #:class_name => 'Adjustment',
                 :conditions => "source_type='LineItem'"
        
      end
      
#      methodz = CoreCharge._save_callbacks.select{|c| c.raw_filter.class == Symbol}
#      CoreCharge.reset_callbacks :save
#      
#      methodz.each do |methud|
#        CoreCharge.set_callback :save, methud.kind, methud.raw_filter
#      end
      
    end
    
    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare &method(:activate).to_proc
  end
end
