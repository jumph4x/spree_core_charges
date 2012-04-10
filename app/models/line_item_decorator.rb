Spree::LineItem.class_eval do
  def update_adjustment(adjustment, source)
    current_amount = adjustment.amount
    adjustment.amount = if adjustment.adjustable(true).line_items.include? adjustment.source
      calculate_core_charge
    else
      0
    end
    if current_amount != adjustment.amount
      Spree::Adjustment.skip_callback :save, :after, :update_adjustable
      adjustment.save
      Spree::Adjustment.set_callback :save, :after, :update_adjustable
    end
   end
  
  def eligible?(source = nil)
    !!self.product.core_amount
  end

  def calculate_core_charge
    return unless product.core_amount
    - self.quantity * product.core_amount
  end
end
