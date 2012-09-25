Spree::LineItem.class_eval do
  def update_adjustment(adjustment, source) #source being the order
    new_amount = if adjustment.originator and source.line_items.include? adjustment.originator
      calculate_core_charge
    else
      0
    end

    adjustment.update_attribute_without_callbacks(:amount, new_amount)
     
   # Spree::Adjustment.skip_callback :save, :after, :update_adjustable
   # adjustment.save
   # Spree::Adjustment.set_callback :save, :after, :update_adjustable
   end
  
  def eligible?(source = nil)
    !!self.product.core_amount
  end

  def calculate_core_charge
    return unless product.core_amount
    self.quantity * product.core_amount
  end
end
