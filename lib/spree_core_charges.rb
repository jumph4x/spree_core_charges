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
          current_amount = adjustment.amount
          adjustment.amount = if adjustment.order(true).line_items.include? source
            calculate_core_charge
          else
            0
          end
          if current_amount != adjustment.amount
            Adjustment.skip_callback :save, :after, :update_order
            adjustment.save
            Adjustment.set_callback :save, :after, :update_order
          end
        end
        
        def calculate_core_charge
          return unless product.core_amount
          self.quantity * product.core_amount
        end
        
      private
        
        def create_core_charges
          return true if order.core_charges.detect{|cc| cc.source_id == id}
          
          order.core_charges << CoreCharge.create({
            :label =>  "#{I18n.t(:core_charge)} [#{variant.sku}]",
            :source => self,
            :order => order,
            :originator => self,
            :amount => calculate_core_charge
          })
        end
        
        def destroy_core_charges
          order.core_charges.select{|cc| cc.source_id == id}.map(&:destroy)
        end
        
        def update_core_charges

          if self.destroyed?
            destroy_core_charges
          elsif 
            create_core_charges
          end

        end
      
        def update_order
          update_core_charges if product.core_amount
          
          # update the order totals, etc.
          
          order.update!
        end
      
      end
      
      Order.class_eval do

        has_many :core_charges,
                 :dependent => :destroy,
                 #:class_name => 'Adjustment',
                 :conditions => "source_type='LineItem'"
        
      end
    end
    
    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare &method(:activate).to_proc
  end
end
