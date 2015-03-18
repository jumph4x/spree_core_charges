Spree::LineItem.class_eval do
  def calculate_core_charge
    return unless product.core_amount
    self.quantity * product.core_amount
  end
end