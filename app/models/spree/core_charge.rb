class Spree::CoreCharge < Spree::Adjustment
  belongs_to :order
  scope :with_order, :conditions => "order_id IS NOT NULL"
  
  before_validation :set_amount

  # We check if core charges even apply to this order
  # For this we see if any associated products have their core amounts set
  def applicable?
    order.line_items.include? source
  end

  def update!
    set_amount
    save
  end

  # Calculates core charges by summing relevant ones
  def set_amount
    self.amount = (source.product.core_amount * source.quantity)
  end
  
  def update_order
    
  end
  
end
