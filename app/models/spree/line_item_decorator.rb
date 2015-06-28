Spree::LineItem.class_eval do
  after_save :update_core_charges
  before_destroy :destroy_core_charges

  def calculate_core_charge
    return unless product.core_amount
    self.quantity * product.core_amount
  end

  def compute_amount o
    calculate_core_charge
  end

  def core_charge
    order.adjustments.find{|adj| adj.source_id == id}
  end

  def update_core_charges
    core_charge and core_charge.update!
  end

  def destroy_core_charges
    core_charge and core_charge.destroy
  end

end
