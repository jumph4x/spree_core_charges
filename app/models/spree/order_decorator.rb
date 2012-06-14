Spree::Order.class_eval do

  def core_charges
    adjustments.where(:source_type => 'Spree::LineItem')
  end

  def create_core_charges
    applicable_charges, charges_to_destroy = self.core_charges.partition{|cc| cc.originator && cc.originator.eligible? }
    charges_to_destroy.each(&:delete)
    line_item_with_core_charge_ids = applicable_charges.map(&:source_id)
    
    self.line_items.reload.each do |li|
      next unless li.product.core_amount
      
      self.core_charges << Spree::Adjustment.create({
        :label =>  "#{I18n.t(:core_charge)} [#{li.variant.sku}]",
        :source => li,
        :adjustable => self,
        :originator => li,
        :amount => li.calculate_core_charge,
        :eligible => true
      }) unless line_item_with_core_charge_ids.include?(li.id)
    end
  end

end
